'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation'; // 1. Import router để chuyển trang nếu chưa login
import { CheckCircle, FileText, ChevronLeft, ChevronRight } from 'lucide-react';

interface Reminder {
  tenBaiKiemTra: string;
  tenMonHoc: string;
  hanChotNopBai: string;
  soGioConLai: number;
  trangThai: string;
}

export default function DashboardPage() {
  const [reminders, setReminders] = useState<Reminder[]>([]);
  const [loading, setLoading] = useState(true);
  
  // 2. Thay biến const userId cứng thành state
  const [userId, setUserId] = useState<string | null>(null);
  
  const [currentDate, setCurrentDate] = useState(new Date(2025, 11, 1)); 
  const router = useRouter();

  // --- EFFECT 1: LẤY USER TỪ LOCALSTORAGE ---
  useEffect(() => {
    // Lấy chuỗi JSON đã lưu lúc đăng nhập
    const storedUserStr = localStorage.getItem("NguoiDung");
    
    if (storedUserStr) {
        try {
            const user = JSON.parse(storedUserStr);
            const id = user.maNguoiDung;
            
            if (id) {
                setUserId(id);
            } else {
                console.error("Không tìm thấy ID trong thông tin user");
            }
        } catch (error) {
            console.error("Lỗi đọc dữ liệu user", error);
        }
    }
  }, [router]);

  // --- EFFECT 2: GỌI API DASHBOARD (Chỉ chạy khi có userId) ---
  useEffect(() => {
    if (!userId) return; // Nếu chưa lấy được ID thì chưa gọi API

    setLoading(true);
    fetch(`http://localhost:8080/api/dashboard/${userId}`) // Dùng userId động
      .then(res => res.json())
      .then(data => {
        if (data && data.lichNhacNho) {
            setReminders(data.lichNhacNho);
        }
        setLoading(false);
      })
      .catch(err => {
        console.error(err);
        setLoading(false);
      });
  }, [userId]); // Thêm userId vào dependency array để chạy lại khi có ID

  // --- HELPER: Format ngày tiếng Việt ---
  const formatDateVN = (dateString: string) => {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('vi-VN', { 
        weekday: 'long', 
        day: 'numeric', 
        month: 'long', 
        year: 'numeric' 
    }).format(date);
  };

  // --- LOGIC 1: TIMELINE ---
  const groupedReminders = reminders.reduce((groups, item) => {
    const date = item.hanChotNopBai.split('T')[0];
    if (!groups[date]) groups[date] = [];
    groups[date].push(item);
    return groups;
  }, {} as Record<string, Reminder[]>);

  const sortedDates = Object.keys(groupedReminders).sort((a, b) => new Date(a).getTime() - new Date(b).getTime());

  // --- LOGIC 2: CALENDAR ---
  const renderCalendar = () => {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    let startDayOfWeek = new Date(year, month, 1).getDay(); 
    startDayOfWeek = startDayOfWeek === 0 ? 6 : startDayOfWeek - 1; 
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const blanks = Array.from({ length: startDayOfWeek }, (_, i) => i);
    const days = Array.from({ length: daysInMonth }, (_, i) => i + 1);

    return (
        <div className="grid grid-cols-7 gap-0 text-sm border-t border-l border-gray-200">
            {['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map(d => (
                <div key={d} className="p-2 bg-gray-50 border-r border-b font-semibold text-center text-gray-500 uppercase text-xs">
                    {d}
                </div>
            ))}
            {blanks.map(i => <div key={`blank-${i}`} className="border-r border-b h-24 bg-gray-50/30"></div>)}
            {days.map(day => {
                const eventsToday = reminders.filter(r => {
                    const rDate = new Date(r.hanChotNopBai);
                    return rDate.getDate() === day && rDate.getMonth() === month && rDate.getFullYear() === year;
                });
                return (
                    <div key={day} className="border-r border-b h-24 p-1 relative hover:bg-blue-50 transition-colors group">
                        <span className={`text-xs font-medium w-6 h-6 flex items-center justify-center rounded-full ${
                            eventsToday.length > 0 ? 'bg-[#0073B7] text-white' : 'text-gray-700'
                        }`}>
                            {day}
                        </span>
                        <div className="mt-1 flex flex-col gap-1 overflow-y-auto max-h-[60px] custom-scrollbar">
                            {eventsToday.map((ev, idx) => (
                                <div key={idx} className="text-[10px] text-[#0073B7] truncate flex items-center gap-1 bg-blue-50 px-1 rounded border border-blue-100" title={ev.tenBaiKiemTra}>
                                    <div className="w-1.5 h-1.5 rounded-full bg-orange-500 shrink-0"></div>
                                    <span className="truncate">{ev.tenBaiKiemTra}</span>
                                </div>
                            ))}
                        </div>
                    </div>
                );
            })}
        </div>
    );
  };

  const nextMonth = () => setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1));
  const prevMonth = () => setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1));

  // 3. Render loading hoặc nội dung
  if (loading || !userId) return <div className="p-10 text-center text-gray-500">Đang tải dữ liệu...</div>;

  return (
    <div className="p-6 max-w-6xl mx-auto bg-gray-50 min-h-screen font-sans">
      <h1 className="text-2xl font-bold text-[#0073B7] mb-6">Bảng Điều khiển</h1>

      {/* PHẦN 1: MỐC THỜI GIAN */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 mb-8 overflow-hidden">
        <div className="p-4 border-b border-gray-200 bg-gray-50">
            <h2 className="text-lg font-bold text-[#0073B7]">Mốc thời gian</h2>
        </div>
        
        <div className="p-4 border-b flex gap-3 flex-wrap">
            <select className="border rounded px-3 py-1.5 text-sm bg-white outline-none focus:ring-1 ring-[#0073B7]"><option>30 ngày tới</option></select>
            <input type="text" placeholder="Tìm kiếm hoạt động..." className="border rounded px-3 py-1.5 text-sm flex-1 outline-none focus:ring-1 ring-[#0073B7]" />
        </div>

        <div className="p-6">
            {reminders.length === 0 ? (
                <p className="text-center text-gray-500 py-8">Không có hoạt động sắp tới.</p>
            ) : (
                sortedDates.map((dateKey) => (
                    <div key={dateKey} className="mb-6 last:mb-0">
                        <h3 className="text-[#0073B7] font-bold text-sm mb-3 capitalize border-b pb-1 inline-block border-gray-200">
                            {formatDateVN(dateKey)}
                        </h3>
                        <div className="space-y-3">
                            {groupedReminders[dateKey].map((item, index) => {
                                const time = new Date(item.hanChotNopBai).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
                                return (
                                    <div key={index} className="flex flex-col md:flex-row md:items-center bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-all gap-4 group">
                                        <div className="flex items-start gap-3 w-28 shrink-0">
                                            <div className="mt-1">{item.tenBaiKiemTra.toLowerCase().includes('quiz') ? <CheckCircle size={18} className="text-orange-500" /> : <FileText size={18} className="text-[#0073B7]" />}</div>
                                            <span className="text-sm font-bold text-gray-700">{time}</span>
                                        </div>
                                        <div className="flex-1">
                                            <h4 className="text-[#0073B7] font-medium group-hover:underline cursor-pointer transition-all">{item.tenBaiKiemTra}</h4>
                                            <p className="text-xs text-gray-500 mt-1">{item.tenMonHoc} • <span className="text-orange-600 font-medium">{item.soGioConLai} giờ còn lại</span></p>
                                        </div>
                                        <button className={`text-xs border rounded px-4 py-2 font-medium transition-colors ${item.soGioConLai > 0 ? 'bg-[#0073B7] text-white border-[#0073B7] hover:bg-[#005a8e]' : 'bg-gray-100 text-gray-400 cursor-not-allowed'}`}>
                                            {item.soGioConLai > 0 ? 'Thêm bài nộp' : 'Đã đóng'}
                                        </button>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                ))
            )}
        </div>
      </div>

      {/* PHẦN 2: LỊCH */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        <div className="p-4 border-b border-gray-200 flex justify-between items-center bg-gray-50">
             <h2 className="text-lg font-bold text-[#0073B7]">Lịch</h2>
             <button className="bg-[#0073B7] text-white px-3 py-1.5 rounded text-xs font-bold shadow-sm hover:bg-[#00629c]">
                 SỰ KIỆN MỚI
             </button>
        </div>
        
        <div className="p-4 flex justify-between items-center border-b">
            <select className="border rounded px-3 py-1.5 text-sm bg-white focus:ring-1 ring-[#0073B7]"><option>Tất cả các khoá học</option></select>
            <div className="flex items-center gap-4 text-sm text-gray-600 select-none">
                <div onClick={prevMonth} className="cursor-pointer hover:text-[#0073B7] flex items-center p-1"><ChevronLeft size={16}/> Trước</div>
                <div className="font-bold text-[#0073B7] uppercase text-base">
                    Tháng {currentDate.getMonth() + 1} {currentDate.getFullYear()}
                </div>
                <div onClick={nextMonth} className="cursor-pointer hover:text-[#0073B7] flex items-center p-1">Sau <ChevronRight size={16}/></div>
            </div>
        </div>

        {renderCalendar()}
      </div>
    </div>
  );
}