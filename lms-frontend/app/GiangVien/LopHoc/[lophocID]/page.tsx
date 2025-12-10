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
} from 'lucide-react';

// 1. Khai báo kiểu dữ liệu (Khớp với DTO Backend trả về)
interface TaiLieu {
  maTaiLieu: number;
  tenTaiLieu: string;
  loaiTaiLieu: string; // 'pdf', 'video', 'link'
  linkLienKet: string;
  moTa: string;
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
        </div>

        <div className="max-w-5xl mx-auto">
          
          {/* DANH SÁCH CÁC MỤC (SECTIONS) */}
          <div className="space-y-6">
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
    </div>
  );
}
