'use client';

import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { 
  FileText, 
  Video, 
  Link as LinkIcon, 
  ChevronDown, 
  ChevronRight,
  ArrowLeft,
  Plus,
  Trash2,
  Edit2,
  X,
} from 'lucide-react';

// 1. Khai báo kiểu dữ liệu (Khớp với DTO Backend trả về)
interface TaiLieu {
  maTaiLieu: number;
  tenTaiLieu: string;
  loaiTaiLieu: string; // 'pdf', 'video', 'link'
  linkLienKet: string;
  moTa: string;
}

interface KhaoSat {
  maKhaoSat: string;
  tenKhaoSat: string;
  moTa: string;
  thoigianBatDau: string;
  thoiGianKetThuc: string;
}

interface MucTaiLieu {
  maMuc: number;
  tenMuc: string;
  taiLieus: TaiLieu[];
  moTa: string;
}

interface ClassDetail {
  maLopHoc: string;
  tenMonHoc: string;
  tenGiangVien: string;
  maNguoiDung: string;
  maKhaoSat?: string;
  khaoSat?: KhaoSat;
  danhSachMuc: MucTaiLieu[];
}

export default function ClassDetailPage() {
  const params = useParams();
  const router = useRouter();
  const lophocID = params.lophocID;

  const [classData, setClassData] = useState<ClassDetail | null>(null);
  const [loading, setLoading] = useState(true);
  
  // State để đóng/mở các mục (Mặc định mở hết)
  const [expandedSections, setExpandedSections] = useState<Record<number, boolean>>({});

  // State cho modal tạo khảo sát
  const [showSurveyModal, setShowSurveyModal] = useState(false);
  const [surveyForm, setSurveyForm] = useState({
    tenKhaoSat: '',
    moTa: '',
    thoigianBatDau: '',
    thoiGianKetThuc: ''
  });
  const [surveyLoading, setSurveyLoading] = useState(false);
  const [surveyError, setSurveyError] = useState('');

  useEffect(() => {
    if (lophocID) {
      fetch(`http://localhost:8080/api/lophoc/detail/${lophocID}`)
        .then((res) => {
            if(!res.ok) throw new Error("Lỗi API");
            return res.json();
        })
        .then((data: ClassDetail) => {
          setClassData(data);
          
          // Mặc định mở tất cả các mục
          const initialExpand: Record<number, boolean> = {};
          data.danhSachMuc.forEach(m => initialExpand[m.maMuc] = true);
          setExpandedSections(initialExpand);
          
          setLoading(false);
        })
        .catch((err) => {
          console.error(err);
          setLoading(false);
        });
    }
  }, [lophocID]);

  // Hàm toggle đóng mở mục
  const toggleSection = (maMuc: number) => {
    setExpandedSections(prev => ({
      ...prev,
      [maMuc]: !prev[maMuc]
    }));
  };

  const handleOpenSurveyModal = () => {
    if (classData) {
      const autoSurveyName = `Khảo sát học phần ${classData.tenMonHoc} (${classData.maLopHoc}) ${classData.tenGiangVien}`;
      
      // Ngày giờ bắt đầu mặc định là hiện tại
      const now = new Date();
      const startDateString = now.toISOString().slice(0, 16);
      
      // Ngày giờ kết thúc mặc định là sau 2 tuần (14 ngày)
      const endDate = new Date(now);
      endDate.setDate(endDate.getDate() + 14);
      const endDateString = endDate.toISOString().slice(0, 16);
      
      setSurveyForm({
        tenKhaoSat: autoSurveyName,
        moTa: 'Khảo sát ý kiến, nhận xét của sinh viên về lớp học nhằm hỗ trợ cải thiện công tác giảng dạy',
        thoigianBatDau: startDateString,
        thoiGianKetThuc: endDateString
      });
      setSurveyError('');
    }
    setShowSurveyModal(true);
  };

  const handleCreateSurvey = async () => {
    setSurveyError('');
    
    if (!surveyForm.tenKhaoSat.trim()) {
      setSurveyError('Vui lòng nhập tên khảo sát');
      return;
    }

    if (!surveyForm.thoigianBatDau || !surveyForm.thoiGianKetThuc) {
      setSurveyError('Vui lòng chọn thời gian bắt đầu và kết thúc');
      return;
    }

    const startDate = new Date(surveyForm.thoigianBatDau);
    const endDate = new Date(surveyForm.thoiGianKetThuc);

    if (endDate <= startDate) {
      setSurveyError('Thời gian kết thúc phải sau thời gian bắt đầu');
      return;
    }

    const daysDiff = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24);
    if (daysDiff < 7) {
      setSurveyError('Khảo sát phải kéo dài ít nhất 7 ngày');
      return;
    }

    setSurveyLoading(true);

    try {
      const response = await fetch(`http://localhost:8080/api/lophoc/${lophocID}/create-khao-sat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          tenKhaoSat: surveyForm.tenKhaoSat,
          moTa: surveyForm.moTa,
          thoigianBatDau: surveyForm.thoigianBatDau,
          thoiGianKetThuc: surveyForm.thoiGianKetThuc
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Lỗi tạo khảo sát');
      }

      const data = await response.json();
      if (data.data) {
        setClassData(data.data);
      }

      setSurveyForm({
        tenKhaoSat: '',
        moTa: '',
        thoigianBatDau: '',
        thoiGianKetThuc: ''
      });
      setShowSurveyModal(false);
    } catch (err) {
      setSurveyError(err instanceof Error ? err.message : 'Lỗi không xác định');
    } finally {
      setSurveyLoading(false);
    }
  };

  // Hàm chọn icon dựa theo loại file
  const getIcon = (type: string) => {
    // Chuẩn hóa về chữ thường để so sánh
    const t = type?.toLowerCase() || '';
    if (t.includes('pdf') || t.includes('tài liệu')) return <FileText size={20} className="text-blue-500" />;
    if (t.includes('video') || t.includes('mp4')) return <Video size={20} className="text-red-500" />;
    if (t.includes('link') || t.includes('tham khảo')) return <LinkIcon size={20} className="text-green-600" />;
    return <FileText size={20} className="text-gray-500" />;
  };

  if (loading) return <div className="p-10 text-center text-gray-500">Đang tải dữ liệu lớp học...</div>;
  if (!classData) return <div className="p-10 text-center text-red-500">Không tìm thấy lớp học này.</div>;

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="px-60">
        {/* HEADER với nút quay lại */}
        <div className="flex items-center justify-between mb-6 pt-4">
          <div className="flex items-center gap-4">
            <button
              onClick={() => router.back()}
              className="p-2 hover:bg-gray-200 rounded-full transition-colors"
              title="Quay lại"
            >
              <ArrowLeft size={24} className="text-[#0073B7]" />
            </button>
            <div>
              <h1 className="text-2xl font-bold text-[#0073B7]">
                {classData.tenMonHoc} ({classData.maLopHoc})
              </h1>
              <h2 className="mt-2 text-[14px] font-bold text-gray-400">
                Giảng viên: {classData.tenGiangVien} ({classData.maNguoiDung})
              </h2>
            </div>
          </div>

          {/* Nút Thêm mục */}
          <button
            onClick={() => {
              // TODO: Mở modal thêm mục
              alert('Chức năng thêm mục sẽ được triển khai');
            }}
            className="flex items-center gap-2 bg-[#0073B7] hover:bg-[#005a91] text-white px-4 py-2 rounded text-sm font-medium transition-colors"
          >
            <Plus size={18} />
            Thêm mục
          </button>

          {!classData?.maKhaoSat && (
            <button
              onClick={handleOpenSurveyModal}
              className="flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded text-sm font-medium transition-colors"
            >
              <Plus size={18} />
              Tạo khảo sát
            </button>
          )}
        </div>

        <div className="max-w-5xl mx-auto">
          
          {/* DANH SÁCH CÁC MỤC (SECTIONS) */}
          <div className="space-y-6">
            {/* Khảo Sát */}
            {classData?.khaoSat && (
              <div className="bg-white rounded-[20px] shadow-sm border border-gray-200 overflow-hidden">
                <div className="flex gap-4 mb-3 items-start justify-between p-4">
                  <div className="flex gap-4 flex-1">
                    <button 
                      onClick={() => toggleSection(-1)}
                      className="p-1 bg-gray-50 border-[2px] border-gray-100 rounded-full hover:bg-gray-100 hover:border-[#0073B7] transition-colors flex-shrink-0"
                    >
                      {expandedSections[-1] ? (
                        <ChevronDown size={24} className="text-[#0073B7]" />
                      ) : (
                        <ChevronRight size={24} className="text-[#0073B7]" />
                      )}
                    </button>
                    <div className="space-y-1 flex-1">                            
                      <h3 className="font-bold text-lg text-gray-800">
                        {classData.khaoSat.tenKhaoSat}
                      </h3>
                      
                      {classData.khaoSat.moTa && (
                        <p className="text-sm text-gray-400 font-normal">
                          {classData.khaoSat.moTa}
                        </p>
                      )}
                    </div>
                  </div>

                  {/* Action buttons */}
                  <div className="flex gap-2">
                    <button
                      onClick={() => {
                        alert('Chức năng chỉnh sửa khảo sát sẽ được triển khai');
                      }}
                      className="p-2 hover:bg-blue-100 text-[#0073B7] rounded transition-colors"
                      title="Chỉnh sửa khảo sát"
                    >
                      <Edit2 size={18} />
                    </button>
                    <button
                      onClick={() => {
                        if (confirm('Bạn chắc chắn muốn xóa khảo sát này?')) {
                          alert('Chức năng xóa khảo sát sẽ được triển khai');
                        }
                      }}
                      className="p-2 hover:bg-red-100 text-red-600 rounded transition-colors"
                      title="Xóa khảo sát"
                    >
                      <Trash2 size={18} />
                    </button>
                  </div>
                </div>

                {/* Nội dung khảo sát */}
                {expandedSections[-1] && (
                  <div className="px-4 pb-4">
                    <div className="space-y-2">
                      <p className="text-sm"><strong>Thời gian bắt đầu:</strong> {new Date(classData.khaoSat.thoigianBatDau).toLocaleString('vi-VN')}</p>
                      <p className="text-sm"><strong>Thời gian kết thúc:</strong> {new Date(classData.khaoSat.thoiGianKetThuc).toLocaleString('vi-VN')}</p>
                    </div>
                  </div>
                )}
              </div>
            )}

            {classData.danhSachMuc.map((muc) => {
              const isExpanded = expandedSections[muc.maMuc];

              return (
                <div key={muc.maMuc} className="bg-white rounded-[20px] shadow-sm border border-gray-200 overflow-hidden">
                  
                  {/* Tiêu đề Mục với các action button */}
                  <div className="flex gap-4 mb-3 items-start justify-between p-4">
                    <div className="flex gap-4 flex-1">
                      <button 
                        onClick={() => toggleSection(muc.maMuc)}
                        className="p-1 bg-gray-50 border-[2px] border-gray-100 rounded-full hover:bg-gray-100 hover:border-[#0073B7] transition-colors flex-shrink-0"
                      >
                        {isExpanded ? (
                          <ChevronDown size={24} className="text-[#0073B7]" />
                        ) : (
                          <ChevronRight size={24} className="text-[#0073B7]" />
                        )}
                      </button>
                      <div className="space-y-1 flex-1">                            
                        <h3 className="font-bold text-lg text-gray-800">
                          {muc.tenMuc}
                        </h3>
                        
                        {muc.moTa && (
                          <p className="text-sm text-gray-400 font-normal">
                            {muc.moTa}
                          </p>
                        )}
                      </div>
                    </div>

                    {/* Action buttons */}
                    <div className="flex gap-2">
                      <button
                        onClick={() => {
                          // TODO: Chỉnh sửa mục
                          alert('Chức năng chỉnh sửa mục sẽ được triển khai');
                        }}
                        className="p-2 hover:bg-blue-100 text-[#0073B7] rounded transition-colors"
                        title="Chỉnh sửa mục"
                      >
                        <Edit2 size={18} />
                      </button>
                      <button
                        onClick={() => {
                          // TODO: Xóa mục
                          if (confirm('Bạn chắc chắn muốn xóa mục này?')) {
                            alert('Chức năng xóa mục sẽ được triển khai');
                          }
                        }}
                        className="p-2 hover:bg-red-100 text-red-600 rounded transition-colors"
                        title="Xóa mục"
                      >
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </div>

                  {/* Nội dung bên trong Mục */}
                  {isExpanded && (
                    <div className="px-4 pb-4">
                      {muc.taiLieus.length === 0 ? (
                        <div className="p-4 text-gray-400 italic text-sm">Chưa có tài liệu nào trong mục này.</div>
                      ) : (
                        <ul className="space-y-3">
                          {muc.taiLieus.map((tl) => (
                            <li key={tl.maTaiLieu} className="group flex items-start p-3 rounded-md border border-gray-100 hover:border-[#0073B7] transition-colors">
                              {/* Icon */}
                              <div className="mt-0.5 mr-3 p-2">
                                {getIcon(tl.loaiTaiLieu)}
                              </div>

                              {/* Thông tin tài liệu */}
                              <div className="space-y-2 flex-1">
                                <a 
                                  href={tl.linkLienKet} 
                                  target="_blank" 
                                  rel="noopener noreferrer"
                                  className="text-[#0073B7] hover:underline block"
                                >
                                  <div className="font-semibold">
                                    {tl.tenTaiLieu}
                                  </div>                                                
                                  {tl.moTa && (
                                    <p className="text-sm text-gray-400 font-normal">
                                      {tl.moTa}
                                    </p>
                                  )}
                                </a>                                                
                              </div>

                              {/* Action buttons cho tài liệu */}
                              <div className="flex gap-1 ml-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                <button
                                  onClick={() => {
                                    // TODO: Chỉnh sửa tài liệu
                                    alert('Chức năng chỉnh sửa tài liệu sẽ được triển khai');
                                  }}
                                  className="p-1 hover:bg-blue-100 text-[#0073B7] rounded"
                                  title="Chỉnh sửa"
                                >
                                  <Edit2 size={16} />
                                </button>
                                <button
                                  onClick={() => {
                                    // TODO: Xóa tài liệu
                                    if (confirm('Bạn chắc chắn muốn xóa tài liệu này?')) {
                                      alert('Chức năng xóa tài liệu sẽ được triển khai');
                                    }
                                  }}
                                  className="p-1 hover:bg-red-100 text-red-600 rounded"
                                  title="Xóa"
                                >
                                  <Trash2 size={16} />
                                </button>
                              </div>
                            </li>
                          ))}
                        </ul>
                      )}

                      {/* Nút thêm tài liệu vào mục */}
                      <button
                        onClick={() => {
                          // TODO: Thêm tài liệu
                          alert('Chức năng thêm tài liệu sẽ được triển khai');
                        }}
                        className="mt-4 w-full p-3 border-2 border-dashed border-gray-300 rounded hover:border-[#0073B7] text-[#0073B7] font-medium transition-colors"
                      >
                        + Thêm tài liệu
                      </button>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Modal Tạo Khảo Sát */}
      {showSurveyModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-lg p-6 w-96">
            <h2 className="text-xl font-bold text-[#0073B7] mb-4">
              Tạo Khảo Sát
            </h2>

            {surveyError && (
              <div className="mb-4 p-2 bg-red-100 border border-red-400 text-red-700 rounded text-sm">
                {surveyError}
              </div>
            )}

            <div className="space-y-4">
              {/* Tên khảo sát - không thể thay đổi */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Tên khảo sát
                </label>
                <div className="w-full border border-gray-300 rounded px-3 py-2 text-sm bg-gray-200 text-gray-900">
                  {surveyForm.tenKhaoSat}
                </div>
              </div>

              {/* Mô tả */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Mô tả
                </label>
                <textarea
                  value={surveyForm.moTa}
                  onChange={(e) => setSurveyForm({...surveyForm, moTa: e.target.value})}
                  className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white resize-none"
                  placeholder="Nhập mô tả cho khảo sát"
                  rows={3}
                />
              </div>

              {/* Thời gian bắt đầu */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Thời gian bắt đầu
                </label>
                <input
                  type="datetime-local"
                  value={surveyForm.thoigianBatDau}
                  onChange={(e) => setSurveyForm({...surveyForm, thoigianBatDau: e.target.value})}
                  className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white"
                />
              </div>

              {/* Thời gian kết thúc */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Thời gian kết thúc
                </label>
                <input
                  type="datetime-local"
                  value={surveyForm.thoiGianKetThuc}
                  onChange={(e) => setSurveyForm({...surveyForm, thoiGianKetThuc: e.target.value})}
                  className="w-full border border-gray-300 rounded px-3 py-2 text-sm text-gray-900 bg-blue-50 focus:outline-none focus:border-[#0073B7] focus:bg-white"
                />
              </div>
            </div>

            <div className="flex justify-end gap-2 mt-6">
              <button
                onClick={() => {
                  setShowSurveyModal(false);
                  setSurveyError('');
                }}
                className="px-4 py-2 text-sm font-medium text-gray-700 border border-gray-300 rounded hover:bg-gray-50"
              >
                Hủy
              </button>
              <button
                onClick={handleCreateSurvey}
                disabled={surveyLoading}
                className="px-4 py-2 text-sm font-medium text-white bg-[#0073B7] rounded hover:bg-[#005a8e] disabled:bg-gray-400"
              >
                {surveyLoading ? 'Đang tạo...' : 'Tạo khảo sát'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
