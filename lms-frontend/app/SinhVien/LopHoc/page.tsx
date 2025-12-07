'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { MoreHorizontal } from 'lucide-react';

// Định nghĩa kiểu dữ liệu
interface LopHoc {
  maLopHoc: string;
  maMonHoc: string;
  maNguoiDay: string;
}

interface UserInfo {
  maNguoiDung: string;
  hoTen: string;
}

// Mảng màu background giả lập để giống ảnh Moodle
const CARD_PATTERNS = [
    "bg-gradient-to-br from-blue-400 to-blue-600",
    "bg-gradient-to-br from-purple-400 to-indigo-600",
    "bg-gradient-to-br from-pink-400 to-rose-500",
    "bg-gradient-to-br from-emerald-400 to-teal-600",
    "bg-gradient-to-br from-orange-400 to-amber-500",
];

export default function MyCoursesPage() {
  const router = useRouter();
  const [classes, setClasses] = useState<LopHoc[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // 1. Lấy user
    const storedUser = localStorage.getItem('NguoiDung');
    if (!storedUser) {
      router.push('/Login');
      return;
    }
    const user: UserInfo = JSON.parse(storedUser);

    // 2. Gọi API lấy lớp
    fetch(`http://localhost:8080/api/lophoc/SinhVien/${user.maNguoiDung}`)
      .then((res) => res.json())
      .then((data) => {
        setClasses(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        setLoading(false);
      });
  }, [router]);

  if (loading) return <div className="p-10 text-center">Đang tải khóa học...</div>;

  return (
    <div className="px-50">
      <h2 className="text-2xl font-bold text-[#0073B7] mb-6">Các khoá học của tôi</h2>

      {/* Bộ lọc & Tìm kiếm (Giống ảnh) */}
      <div className="flex gap-2 mb-6">
        <select className="border border-gray-300 rounded px-3 py-1.5 text-sm bg-white focus:outline-none focus:border-[#0073B7]">
            <option>All (Except removed from view)</option>
            <option>In progress</option>
            <option>Future</option>
        </select>
        <input 
            type="text" 
            placeholder="Tìm kiếm" 
            className="border border-gray-300 rounded px-3 py-1.5 text-sm w-64 focus:outline-none focus:border-[#0073B7]"
        />
      </div>

      {/* Grid danh sách lớp */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {classes.map((lop, index) => {
            // Chọn màu ngẫu nhiên dựa theo index
            const bgPattern = CARD_PATTERNS[index % CARD_PATTERNS.length];

            return (
              <div 
                key={lop.maLopHoc} 
                className="bg-white rounded shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow cursor-pointer flex flex-col"
                onClick={() => alert("Vào lớp: " + lop.maLopHoc)}
              >
                {/* 1. Phần hình ảnh cover (Màu sắc) */}
                <div className={`h-30 ${bgPattern} relative p-4`}>
                    {/* Nút 3 chấm góc phải */}
                    <button className="absolute top-2 right-2 p-1 bg-black/20 text-white rounded hover:bg-black/30">
                        <MoreHorizontal size={16} />
                    </button>
                </div>

                {/* 2. Phần nội dung */}
                <div className="p-4 flex flex-col justify-between flex-grow">
                    <div>
                        <p className="text-xs text-gray-500 font-semibold uppercase mb-1">
                            {lop.maNguoiDay}
                        </p>
                        <h3 className="text-[15px] font-bold text-[#0073B7] leading-snug line-clamp-2 hover:underline">
                            {lop.maMonHoc} - {lop.maLopHoc}
                        </h3>
                    </div>
                </div>
              </div>
            );
        })}
      </div>
    </div>
  );
}