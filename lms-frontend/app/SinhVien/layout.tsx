import Header from "@/app/components/Header";

export default function SinhVienLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col min-h-screen bg-gray-50">
      {/* Header chung */}
      <Header />
      
      {/* Nội dung chính (Thay đổi tùy theo trang con) */}
      <main className="flex-grow w-full max-w-[1400px] mx-auto p-4 sm:p-6">
        {children}
      </main>
      
      {/* Footer (nếu cần) */}
      <footer className="py-6 text-center text-gray-500 text-sm">
        © 12-7-2025 BÀI TẬP LỚN MÔN HỆ CƠ SỞ DỮ LIỆU - LỚP: L06 - NHÓM: L06_66
      </footer>
    </div>
  );
}