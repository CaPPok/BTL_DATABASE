'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { 
  FileText, 
  Video, 
  Link as LinkIcon, 
  ChevronDown, 
  ChevronRight,
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
  // Lấy ID từ URL (VD: HK251_CO2013_L01)
  const params = useParams();
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
            {/* 1. HEADER TÊN LỚP (Giống ảnh Moodle) */}
            <div className="mb-6">
                <h1 className="text-2xl font-bold text-[#0073B7]">
                {classData.tenMonHoc} ({classData.maLopHoc})
                </h1>
                <h1 className="mt-2 text-[14px] font-bold text-gray-400">
                Giảng viên: {classData.tenGiangVien} ({classData.maNguoiDung})
                </h1>
            </div>

            <div className="max-w-5xl mx-auto">
                
                {/* 2. DANH SÁCH CÁC MỤC (SECTIONS) */}
                <div className="space-y-6">
                {classData.danhSachMuc.map((muc) => {
                    const isExpanded = expandedSections[muc.maMuc];

                    return (
                    <div key={muc.maMuc} className="bg-white rounded-[20px] shadow-sm border border-gray-200 overflow-hidden">
                        
                        {/* Tiêu đề Mục (Click để đóng mở) */}
                        <div className="flex gap-4 mb-3">
                            <div 
                                className="m-4 p-1 bg-gray-50 border-[2px] border-gray-100 rounded-full flex items-center justify-between cursor-pointer hover:bg-gray-100 hover:border-[#0073B7] ransition-colors"
                                onClick={() => toggleSection(muc.maMuc)}
                            >
                                <h3 className="font-bold text-lg text-[#0073B7] flex items-center gap-2">
                                    {isExpanded ? <ChevronDown size={24} /> : <ChevronRight size={24} />}                                    
                                </h3>                                                
                            </div>
                            <div className="pt-3 space-y-1">                            
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

                        {/* Nội dung bên trong Mục */}
                        {isExpanded && (
                        <div className="p-2">
                            {muc.taiLieus.length === 0 ? (
                                <div className="p-4 text-gray-400 italic text-sm">Chưa có tài liệu nào trong mục này.</div>
                            ) : (
                                <ul className="space-y-1">
                                    {muc.taiLieus.map((tl) => (
                                        <li key={tl.maTaiLieu} className="group flex items-start p-3 rounded-md transition-colors">
                                            {/* Icon */}                                       
                                            <div className="mt-0.5 mr-3 p-2">
                                                {getIcon(tl.loaiTaiLieu)}
                                            </div>

                                            {/* Thông tin tài liệu */}
                                            <div className="flex-1 space-y-2 ">
                                                <a 
                                                href={tl.linkLienKet} 
                                                target="_blank" 
                                                rel="noopener noreferrer"
                                                className="text-[#0073B7] font-semibold hover:underline flex items-center gap-2"
                                                >
                                                {tl.tenTaiLieu}
                                                </a>
                                                {tl.moTa && (
                                                    <p className="text-sm text-gray-400 font-normal">
                                                        {tl.moTa}
                                                    </p>
                                                )}
                                            </div>
                                        </li>
                                    ))}
                                </ul>
                            )}
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