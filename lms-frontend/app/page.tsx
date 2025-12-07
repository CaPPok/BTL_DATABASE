"use client";

import Image from "next/image";
import { useRouter } from "next/navigation";

export default function Home() {
  const router = useRouter();

  const team = [
    { name: "Bành Phú Hội", role: "2311111" },
    { name: "Lê Gia Bảo", role: "2310226" },
    { name: "Lữ Hoàng Duy", role: "2310474" },
    { name: "Hoàng Thế Huy", role: "2311142" },
    { name: "Nguyễn Văn Hiệp", role: "2311012" },
    { name: "AI", role: "Gemini - Claude - ChatGPT" },
  ];

  return (
    <div className="flex flex-col items-center justify-center min-h-screen text-center pt-10 bg-gradient-to-br from-amber-200 via-orange-100 to-pink-300">
      {/* Logo */}
      <Image
      src="/logoBK.png"
      alt="BK TP.HCM Logo"
      width={120}
      height={120}
      className="object-contain mb-6 drop-shadow-md cursor-pointer"
      />
      {/* Tiêu đề */}
      <h1 className="text-3xl font-bold text-gray-800 mb-3 drop-shadow-md">
        BÀI TẬP LỚN
      </h1>
      <h2 className="text-3xl font-bold text-gray-800 mb-3 drop-shadow-md">
        MÔN HỆ CƠ SỞ DỮ LIỆU
      </h2>
      <h2 className="text-2xl font-bold text-gray-800 mb-10">
        HỌC KỲ: HK251 - LỚP: L06 - NHÓM: L06_66
      </h2>
      {/* Nút đăng nhập */}
      <button
        onClick={() => router.push("/Login")}
        className="px-6 py-3 rounded-xl text-lg font-semibold border border-amber-400 text-amber-700 bg-white/40 backdrop-blur-sm shadow-sm hover:bg-white/60 hover:shadow-md transition-all hover:scale-[1.03] cursor-pointer"
      >
        Bắt đầu
      </button>

      {/* Phần thông tin nhóm */}
      <div className="w-full mt-10 pb-20 bg-gradient-to-t from-amber-50/80 to-transparent flex flex-col items-center">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 px-6 max-w-5xl">
          {team.map((member, index) => (
            <div
              key={index}
              className="bg-white/70 backdrop-blur-md border border-amber-200 shadow-md rounded-2xl p-6 hover:shadow-xl hover:scale-[1.03] transition-all cursor-pointer"
            >
              <div className="w-20 h-20 mx-auto mb-4 rounded-full bg-gradient-to-br from-amber-200 to-orange-300 flex items-center justify-center text-xl font-bold text-gray-800 shadow-inner">
                {member.name[0]}
              </div>
              <h3 className="text-[20px] font-semibold text-gray-800 mb-1">
                {member.name}
              </h3>
              <p className="text-gray-600 text-[16px]">{member.role}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
