'use client';

import { useEffect, useState, useCallback, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { 
  MoreHorizontal, Search, ArrowUpDown, FileSpreadsheet, ChevronLeft, ChevronRight,
  Trash2, Edit2, Plus
} from 'lucide-react'; 

interface LopHoc {
  maLopHoc: string;
  tenMon: string;
  tenGiangVien: string;
  maGV: string;
  maMonHoc: string;
}

interface MonHoc {
  maMonHoc: string;
  tenMonHoc: string;
}

interface GiangVien {
  maNguoiDung: string;
  hoTen: string;
}

const CARD_PATTERNS = [
    "bg-gradient-to-br from-blue-400 to-blue-600",
    "bg-gradient-to-br from-purple-400 to-indigo-600",
    "bg-gradient-to-br from-pink-400 to-rose-500",
    "bg-gradient-to-br from-emerald-400 to-teal-600",
    "bg-gradient-to-br from-orange-400 to-amber-500",
];

export default function GiangVienLopHocPage() {
  const router = useRouter();
  
  // --- STATE HIỂN THỊ ---
  const [allClasses, setAllClasses] = useState<LopHoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [sortOption, setSortOption] = useState("MOI_NHAT");
  const [page, setPage] = useState(0);
  
  // --- STATE FORM ---
  const [showModal, setShowModal] = useState(false);
  const [modalMode, setModalMode] = useState<'add' | 'edit'>('add');
  const [formData, setFormData] = useState({
    maLopHoc: '',
    maMonHoc: '',
    maNguoiDay: '',
  });
  const [editingId, setEditingId] = useState<string | null>(null);
  const [originalMonHoc, setOriginalMonHoc] = useState<string>(''); // Lưu môn học ban đầu
  
  // --- STATE DROPDOWN ---
  const [monHocList, setMonHocList] = useState<MonHoc[]>([]);
  const [giangVienList, setGiangVienList] = useState<GiangVien[]>([]);
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [currentUser, setCurrentUser] = useState<any>(null);

  // CẤU HÌNH: Số lớp tối đa 1 trang
  const PAGE_SIZE = 6; 

  // --- TÍNH TOÁN PHÂN TRANG ---
  const displayedClasses = useMemo(() => {
    const startIndex = page * PAGE_SIZE;
    const endIndex = startIndex + PAGE_SIZE;
    return allClasses.slice(startIndex, endIndex);
  }, [page, allClasses]);

  const totalPages = Math.ceil(allClasses.length / PAGE_SIZE);

  // --- HÀM FETCH DANH SÁCH LỚP HỌC ---
  const fetchCourses = useCallback((keyword: string, sort: string) => {
    setLoading(true);
    
    const storedUser = localStorage.getItem('NguoiDung');
    if (!storedUser) {
        setLoading(false);
        return; 
    }
    const user = JSON.parse(storedUser);

    const url = `http://localhost:8080/api/lophoc/tim-kiem?search=${encodeURIComponent(keyword)}&sort=${sort}&maNguoiDung=${user.maNguoiDung}`;

    fetch(url)
      .then((res) => {
        if (!res.ok) throw new Error(`Lỗi API: ${res.statusText}`); 
        return res.json();
      })
      .then((data) => {
        let result: LopHoc[] = [];
        if (data && data.content) {
            result = data.content;
        } else if (Array.isArray(data)) {
            result = data;
        }
        setAllClasses(result);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Lỗi fetch:", err);
        setAllClasses([]);
        setLoading(false);
      });
  }, []);

  // --- HÀM FETCH DANH SÁCH MÔN HỌC VÀ GIẢNG VIÊN ---
  const fetchDropdownData = useCallback(() => {
    fetch('http://localhost:8080/api/lophoc/monhoc-list')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setMonHocList(data.map(item => ({
            maMonHoc: item[0],
            tenMonHoc: item[1]
          })));
        }
      })
      .catch(err => console.error('Lỗi fetch môn học:', err));

    fetch('http://localhost:8080/api/lophoc/giangvien-list')
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setGiangVienList(data.map(item => ({
            maNguoiDung: item[0],
            hoTen: item[1]
          })));
        }
      })
      .catch(err => console.error('Lỗi fetch giảng viên:', err));
  }, []);

  // --- EFFECT: LOAD DỮ LIỆU LẦN ĐẦU ---
  useEffect(() => {
    // Lấy thông tin người dùng từ localStorage
    const storedUser = localStorage.getItem('NguoiDung');
    if (storedUser) {
      setCurrentUser(JSON.parse(storedUser));
    }
    
    fetchDropdownData();
    setPage(0);
    const delayDebounceFn = setTimeout(() => {
      fetchCourses(searchTerm, sortOption);
    }, 500);
    return () => clearTimeout(delayDebounceFn);
  }, [searchTerm, sortOption, fetchCourses, fetchDropdownData]); 

  // --- HÀM THÊM LỚP HỌC ---
  const handleThem = () => {
    setModalMode('add');
    setFormData({ 
      maLopHoc: '', 
      maMonHoc: '', 
      maNguoiDay: currentUser?.maNguoiDung || '' // Tự động điền mã giảng viên
    });
    setEditingId(null);
    setShowModal(true);
    setError("");
  };

  // --- HÀM SỬA LỚP HỌC ---
  const handleSua = (lop: LopHoc) => {
    setModalMode('edit');
    setFormData({
      maLopHoc: lop.maLopHoc,
      maMonHoc: lop.maMonHoc,
      maNguoiDay: currentUser?.maNguoiDung || '', // Luôn dùng mã giảng viên hiện tại
    });
    setOriginalMonHoc(lop.maMonHoc); // Lưu môn học ban đầu
    setEditingId(lop.maLopHoc);
    setShowModal(true);
    setError("");
  };

  // --- HÀM XÓA LỚP HỌC ---
  const handleXoa = (maLopHoc: string) => {
    if (!confirm(`Bạn có chắc muốn xóa lớp học ${maLopHoc}?`)) return;

    fetch(`http://localhost:8080/api/lophoc/delete/${maLopHoc}`, {
      method: 'DELETE',
    })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'success') {
          setSuccessMessage(data.message);
          setTimeout(() => setSuccessMessage(""), 3000);
          fetchCourses(searchTerm, sortOption);
        } else {
          setError(data.message || "Lỗi xóa lớp học");
        }
      })
      .catch(err => {
        setError("Lỗi kết nối: " + err.message);
      });
  };

  // --- HÀM SUBMIT FORM ---
  const handleSubmit = () => {
    if (!formData.maLopHoc || !formData.maMonHoc || !formData.maNguoiDay) {
      setError("Vui lòng điền đầy đủ thông tin!");
      return;
    }

    if (modalMode === 'add') {
      fetch('http://localhost:8080/api/lophoc/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      })
        .then(res => res.json())
        .then(data => {
          if (data.status === 'success') {
            setSuccessMessage(data.message);
            setTimeout(() => setSuccessMessage(""), 3000);
            setShowModal(false);
            fetchCourses(searchTerm, sortOption);
          } else {
            setError(data.message || "Lỗi thêm lớp học");
          }
        })
        .catch(err => setError("Lỗi kết nối: " + err.message));
    } else {
      fetch(`http://localhost:8080/api/lophoc/update/${editingId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          maMonHoc: formData.maMonHoc,
          maNguoiDay: formData.maNguoiDay,
        }),
      })
        .then(res => res.json())
        .then(data => {
          if (data.status === 'success') {
            setSuccessMessage(data.message);
            setTimeout(() => setSuccessMessage(""), 3000);
            setShowModal(false);
            fetchCourses(searchTerm, sortOption);
          } else {
            setError(data.message || "Lỗi sửa lớp học");
          }
        })
        .catch(err => setError("Lỗi kết nối: " + err.message));
    }
  };

  // --- HÀM XUẤT EXCEL ---
  const handleExport = () => {
    const storedUser = localStorage.getItem('NguoiDung');
    if (storedUser) {
      const user = JSON.parse(storedUser);
      const exportUrl = `http://localhost:8080/api/lophoc/export?search=${encodeURIComponent(searchTerm)}&sort=${sortOption}&maNguoiDung=${user.maNguoiDung}`;
      window.open(exportUrl, '_blank');
    }
  };

  return (
    <div className="px-50 py-8">
      <h2 className="text-2xl font-bold text-[#0073B7] mb-6">Quản lý lớp học</h2>

      <div className="flex flex-wrap gap-3 mb-6 items-center justify-between">
        
        {/* KHUNG TÌM KIẾM */}
        <div className="relative flex-1 max-w-md">
            <input 
                type="text" 
                placeholder="Tìm môn học, lớp..." 
                className="border border-gray-300 rounded pl-10 pr-4 py-2 text-sm w-full focus:outline-none focus:border-[#0073B7] shadow-sm"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
            />
             <div className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                <Search size={18} />
            </div>
        </div>

        {/* KHUNG CHỨC NĂNG */}
        <div className="flex items-center gap-3">
            <button 
                onClick={handleThem}
                className="flex items-center gap-2 bg-[#0073B7] hover:bg-[#005a8e] text-white px-4 py-2 rounded text-sm font-medium shadow-sm transition-colors duration-200"
            >
                <Plus size={18} />
                <span>Thêm lớp học</span>
            </button>

            <button 
                onClick={handleExport}
                className="flex items-center gap-2 bg-[#28a745] hover:bg-[#218838] text-white px-4 py-2 rounded text-sm font-medium shadow-sm transition-colors duration-200"
            >
                <FileSpreadsheet size={18} />
                <span>Xuất Excel</span>
            </button>

            <div className="flex items-center gap-2">
                <label className="text-sm font-medium text-gray-600 flex items-center gap-1">
                    <ArrowUpDown size={16} /> Sắp xếp:
                </label>
                <select 
                    className="border border-gray-300 rounded px-3 py-2 text-sm bg-white focus:outline-none focus:border-[#0073B7] shadow-sm cursor-pointer"
                    value={sortOption}
                    onChange={(e) => setSortOption(e.target.value)}
                >
                    <option value="TEN_AZ">Tên môn (A - Z)</option>
                    <option value="TEN_ZA">Tên môn (Z - A)</option>
                    <option value="MOI_NHAT">Mới nhất</option>
                </select>
            </div>
        </div>
      </div>

      {/* THÔNG BÁO */}
      {error && (
        <div className="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
          {error}
        </div>
      )}
      {successMessage && (
        <div className="mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded">
          {successMessage}
        </div>
      )}

      {/* GRID DANH SÁCH */}
      {loading ? (
         <div className="p-10 text-center text-gray-500">Đang tải dữ liệu...</div>
      ) : displayedClasses.length === 0 ? (
         <div className="p-10 text-center text-gray-400 italic">Không tìm thấy kết quả nào.</div>
      ) : (
        <>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {displayedClasses.map((lop, index) => {
                    const bgPattern = CARD_PATTERNS[index % CARD_PATTERNS.length];
                    return (
                    <div 
                        key={lop.maLopHoc} 
                        className="bg-white rounded-[5px] shadow-sm border border-gray-200 overflow-hidden hover:shadow-[0px_4px_10px_rgba(0,0,0,0.3)] hover:translate-y-[-5px] transition-shadow flex flex-col group relative"
                    >
                        <div className={`h-28 ${bgPattern} relative p-4`}>
                            <div className="absolute top-2 right-2 flex gap-1">
                                <button 
                                  onClick={() => handleSua(lop)}
                                  className="p-1.5 bg-blue-500/80 hover:bg-blue-600 text-white rounded transition-colors"
                                  title="Sửa"
                                >
                                    <Edit2 size={14} />
                                </button>
                                <button 
                                  onClick={() => handleXoa(lop.maLopHoc)}
                                  className="p-1.5 bg-red-500/80 hover:bg-red-600 text-white rounded transition-colors"
                                  title="Xóa"
                                >
                                    <Trash2 size={14} />
                                </button>
                            </div>
                        </div>

                        <div className="p-4 flex flex-col justify-between flex-grow">
                            <div>
                                <p className="text-xs text-gray-500 font-semibold uppercase mb-1 truncate">
                                    {lop.tenGiangVien} <span className="text-gray-400">({lop.maGV})</span>
                                </p>
                                <h3 className="text-[15px] font-bold text-[#0073B7] leading-snug line-clamp-2">
                                    {lop.tenMon}
                                </h3>
                                <p className="text-xs text-gray-400 mt-1">Lớp: {lop.maLopHoc}</p>
                            </div>
                        </div>
                    </div>
                    );
                })}
            </div>

            {/* THANH PHÂN TRANG */}
            {totalPages > 1 && (
                <div className="flex justify-center items-center mt-8 gap-4 select-none">
                    <button 
                        disabled={page === 0}
                        onClick={() => setPage(p => Math.max(0, p - 1))}
                        className={`flex items-center gap-1 px-4 py-2 rounded-md text-sm font-medium border transition-colors ${
                            page === 0 
                            ? 'bg-gray-100 text-gray-400 cursor-not-allowed border-gray-200' 
                            : 'bg-white text-gray-700 hover:bg-gray-50 border-gray-300 hover:text-[#0073B7]'
                        }`}
                    >
                        <ChevronLeft size={16} /> Trước
                    </button>
                    
                    <span className="text-sm font-medium text-gray-600">
                        Trang <span className="text-[#0073B7] font-bold">{page + 1}</span> / {totalPages}
                    </span>

                    <button 
                        disabled={page >= totalPages - 1}
                        onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
                        className={`flex items-center gap-1 px-4 py-2 rounded-md text-sm font-medium border transition-colors ${
                            page >= totalPages - 1 
                            ? 'bg-gray-100 text-gray-400 cursor-not-allowed border-gray-200' 
                            : 'bg-white text-gray-700 hover:bg-gray-50 border-gray-300 hover:text-[#0073B7]'
                        }`}
                    >
                        Sau <ChevronRight size={16} />
                    </button>
                </div>
            )}
        </>
      )}

      {/* MODAL THÊM/SỬA */}
      {showModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-lg p-6 w-96">
            <h2 className="text-xl font-bold text-[#0073B7] mb-4">
              {modalMode === 'add' ? 'Thêm lớp học' : 'Sửa lớp học'}
            </h2>

            {error && (
              <div className="mb-4 p-2 bg-red-100 border border-red-400 text-red-700 rounded text-sm">
                {error}
              </div>
            )}

            <div className="space-y-4">
              {/* Mã Lớp Học */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Mã Lớp Học
                </label>
                <input
                  type="text"
                  disabled={modalMode === 'edit'}
                  value={formData.maLopHoc}
                  onChange={(e) => setFormData({ ...formData, maLopHoc: e.target.value })}
                  className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white disabled:bg-gray-200"
                  placeholder="VD: HK251_CO2013_L01"
                />
              </div>

              {/* Môn Học */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Môn Học
                </label>
                <select
                  value={formData.maMonHoc}
                  onChange={(e) => setFormData({ ...formData, maMonHoc: e.target.value })}
                  className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white"
                >
                  <option value="">-- Chọn môn học --</option>
                  {monHocList.map(mon => (
                    <option key={mon.maMonHoc} value={mon.maMonHoc}>
                      {mon.tenMonHoc} ({mon.maMonHoc})
                    </option>
                  ))}
                </select>
              </div>

              {/* Giảng Viên */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Giảng Viên
                </label>
                {modalMode === 'add' ? (
                  <div className="w-full border border-gray-300 rounded px-3 py-2 text-sm bg-gray-200 text-gray-900">
                    {currentUser?.hoTen} ({currentUser?.maNguoiDung})
                  </div>
                ) : (
                  <input
                    type="text"
                    value={formData.maNguoiDay}
                    onChange={(e) => setFormData({ ...formData, maNguoiDay: e.target.value })}
                    placeholder="Nhập mã giảng viên"
                    className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white"
                  />
                )}
              </div>
            </div>

            <div className="flex justify-end gap-2 mt-6">
              <button
                onClick={() => setShowModal(false)}
                className="px-4 py-2 text-sm font-medium text-gray-700 border border-gray-300 rounded hover:bg-gray-50"
              >
                Hủy
              </button>
              <button
                onClick={handleSubmit}
                className="px-4 py-2 text-sm font-medium text-white bg-[#0073B7] rounded hover:bg-[#005a8e]"
              >
                {modalMode === 'add' ? 'Thêm' : 'Cập nhật'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
