'use client';
import { useEffect, useState } from 'react';
import Header from "@/app/components/Header";
import { ChevronDown, ChevronRight, Info, Disc } from 'lucide-react'; // Icon giống hình

// Định nghĩa kiểu dữ liệu
interface LopHoc {
  maLopHoc: string;
  maNguoiDay: string;
  maMonHoc: string; // Có từ quan hệ ngược
}

interface MonHoc {
  maMonHoc: string;
  tenMonHoc: string;
  danhSachLop: LopHoc[];
}

export default function MonHocPage() {
  const [monHocs, setMonHocs] = useState<MonHoc[]>([]);

  useEffect(() => {
    fetch('http://localhost:8080/api/monhoc')
      .then((res) => res.json())
      .then((data) => setMonHocs(data))
      .catch((error) => console.error('Lỗi kết nối:', error));
  }, []);

  return (
    <div className="bg-white min-h-screen font-sans text-sm">
      <Header />
      
      <div className="p-4 max-w-6xl mx-auto space-y-2">
          <div className="pl-0 space-y-2">
            {monHocs.map((mh) => (
              <MonHocItem key={mh.maMonHoc} data={mh} />
            ))}
          </div>
      </div>
    </div>
  );
}

// --- COMPONENT CON: TỪNG MÔN HỌC (ACCORDION) ---
function MonHocItem({ data }: { data: MonHoc }) {
  const [isOpen, setIsOpen] = useState(false); // Mặc định mở giống hình

  return (
    <div className="mb-2">
      {/* Header Môn Học (Màu xanh đậm hơn chút giống hình) */}
      <div 
        onClick={() => setIsOpen(!isOpen)}
        className="bg-[#4da7cf] text-white px-2.5 py-2 flex items-center gap-2 cursor-pointer hover:opacity-90 transition-all select-none"
      >
        {isOpen ? <ChevronDown size={14} /> : <ChevronRight size={14} />}
        <span className="font-medium">
          {data.tenMonHoc} - ({data.maMonHoc})
        </span>
      </div>

      {/* Danh sách Lớp học bên trong */}
      {isOpen && (
        <div className="bg-white border-l border-r border-b border-gray-200">
          {data.danhSachLop && data.danhSachLop.length > 0 ? (
            data.danhSachLop.map((lop, index) => (
              <div 
                key={lop.maLopHoc} 
                className={`p-3 flex items-start justify-between gap-3 hover:bg-gray-50 transition ${
                  index !== data.danhSachLop.length - 1 ? 'border-b border-gray-100' : ''
                }`}
              >
                {/* Nội dung bên trái */}
                <div className="flex items-start gap-2 text-[#46a0c9]">
                  {/* Icon quả cầu/group giống hình */}
                  <Disc size={16} className="mt-0.5 shrink-0 animate-spin-slow" /> 
                  
                  <div className="text-gray-600">
                    <span className="text-[#0073B7] font-medium hover:underline cursor-pointer">
                      {/* Format giống hình: Mã lớp - Tên môn - GV - Mã lớp ngắn */}
                      {data.tenMonHoc} ({data.maMonHoc})_{lop.maNguoiDay} [{lop.maLopHoc}]
                    </span>
                  </div>
                </div>

                {/* Icon info bên phải */}
                <button title="Thông tin lớp học" className="text-[#0073B7] hover:text-[#005a8e]">
                  <Info size={18} />
                </button>
              </div>
            ))
          ) : (
            <div className="p-3 text-gray-400 italic pl-10">
              Chưa có lớp học nào được mở.
            </div>
          )}
        </div>
      )}
    </div>
  );
}