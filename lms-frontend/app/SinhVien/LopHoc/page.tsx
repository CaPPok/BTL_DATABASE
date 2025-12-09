'use client';

import { useEffect, useState, useCallback, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { MoreHorizontal, Search, ArrowUpDown, FileSpreadsheet, ChevronLeft, ChevronRight } from 'lucide-react'; 

interface LopHoc {
  maLopHoc: string;
  tenMon: string;
  tenGiangVien: string;
  maGV: string;
  maMonHoc: string;
}

const CARD_PATTERNS = [
    "bg-gradient-to-br from-blue-400 to-blue-600",
    "bg-gradient-to-br from-purple-400 to-indigo-600",
    "bg-gradient-to-br from-pink-400 to-rose-500",
    "bg-gradient-to-br from-emerald-400 to-teal-600",
    "bg-gradient-to-br from-orange-400 to-amber-500",
];

export default function MyCoursesPage() {
  const router = useRouter();
  
  // --- STATE ---
  const [allClasses, setAllClasses] = useState<LopHoc[]>([]); // Chứa TOÀN BỘ dữ liệu tải về
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [sortOption, setSortOption] = useState("MOI_NHAT");
  
  // State phân trang
  const [page, setPage] = useState(0); // Trang hiện tại (0, 1, 2...)
  
  // CẤU HÌNH: Số lớp tối đa 1 trang
  const PAGE_SIZE = 6; 

  // --- LOGIC PHÂN TRANG (CLIENT-SIDE) ---
  // 1. Tính toán danh sách lớp sẽ hiển thị ở trang hiện tại
  const displayedClasses = useMemo(() => {
    const startIndex = page * PAGE_SIZE;
    const endIndex = startIndex + PAGE_SIZE;
    return allClasses.slice(startIndex, endIndex); // Cắt mảng từ vị trí start -> end
  }, [page, allClasses]);

  // 2. Tính tổng số trang dựa trên tổng số lượng lớp
  const totalPages = Math.ceil(allClasses.length / PAGE_SIZE);

  const fetchCourses = useCallback((keyword: string, sort: string) => {
    setLoading(true);
    
    const storedUser = localStorage.getItem('NguoiDung');
    if (!storedUser) {
        setLoading(false);
        return; 
    }
    const user = JSON.parse(storedUser);

    // Gọi API lấy TẤT CẢ (không truyền page/size để frontend tự cắt)
    const url = `http://localhost:8080/api/lophoc/tim-kiem?search=${encodeURIComponent(keyword)}&sort=${sort}&maNguoiDung=${user.maNguoiDung}`;

    fetch(url)
      .then((res) => {
        if (!res.ok) throw new Error(`Lỗi API: ${res.statusText}`); 
        return res.json();
      })
      .then((data) => {
        // Xử lý linh hoạt data trả về
        let result: LopHoc[] = [];
        if (data && data.content) {
            result = data.content; // Nếu API trả về Page object
        } else if (Array.isArray(data)) {
            result = data;         // Nếu API trả về List
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

  // Effect 1: Khi Search/Sort thay đổi -> Reset về trang 0 và gọi API
  useEffect(() => {
    setPage(0); // Reset về trang đầu
    const delayDebounceFn = setTimeout(() => {
      fetchCourses(searchTerm, sortOption);
    }, 500);
    return () => clearTimeout(delayDebounceFn);
  }, [searchTerm, sortOption, fetchCourses]); 


  // Hàm xử lý xuất Excel
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
      <h2 className="text-2xl font-bold text-[#0073B7] mb-6">Tra cứu khóa học</h2>

      <div className="flex flex-wrap gap-3 mb-6 items-center justify-between">
        
        {/* KHUNG TÌM KIẾM */}
        <div className="relative flex-1 max-w-md">
            <input 
                type="text" 
                placeholder="Tìm môn học, giảng viên..." 
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
                onClick={handleExport}
                className="flex items-center gap-2 bg-[#28a745] hover:bg-[#218838] text-white px-4 py-2 rounded text-sm font-medium shadow-sm transition-colors duration-200"
            >
                <FileSpreadsheet size={18} />
                <span>Xuất danh sách khóa học</span>
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

      {/* GRID DANH SÁCH (Render displayedClasses thay vì allClasses) */}
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
                        className="bg-white rounded-[5px] shadow-sm border border-gray-200 overflow-hidden hover:shadow-[0px_4px_10px_rgba(0,0,0,0.3)] hover:translate-y-[-5px] transition-shadow cursor-pointer flex flex-col group"
                        onClick={() => router.push(`/SinhVien/LopHoc/${lop.maLopHoc}`)}
                    >
                        <div className={`h-28 ${bgPattern} relative p-4`}>
                            <button className="absolute top-2 right-2 p-1 bg-black/20 text-white rounded hover:bg-black/30">
                                <MoreHorizontal size={16} />
                            </button>
                        </div>

                        <div className="p-4 flex flex-col justify-between flex-grow">
                            <div>
                                <p className="text-xs text-gray-500 font-semibold uppercase mb-1 truncate">
                                    {lop.tenGiangVien} <span className="text-gray-400">({lop.maGV})</span>
                                </p>
                                <h3 className="text-[15px] font-bold text-[#0073B7] leading-snug line-clamp-2 group-hover:underline">
                                    {lop.tenMon}
                                </h3>
                                <p className="text-xs text-gray-400 mt-1">Lớp: {lop.maLopHoc}</p>
                            </div>
                        </div>
                    </div>
                    );
                })}
            </div>

            {/* --- THANH PHÂN TRANG --- */}
            {/* Chỉ hiện nếu có nhiều hơn 1 trang */}
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
    </div>
  );
}