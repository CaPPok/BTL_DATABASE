package com.example.lms_backend.dto; // <--- DÒNG NÀY RẤT QUAN TRỌNG

import java.util.List;

public class DashboardResponse { // <--- Tên class phải khớp tên file DashboardResponse.java
    private List<DashboardStatDTO> thongKeMonHoc;
    private List<DashboardReminderDTO> lichNhacNho;

    public DashboardResponse() {
    }

    public DashboardResponse(List<DashboardStatDTO> thongKeMonHoc, List<DashboardReminderDTO> lichNhacNho) {
        this.thongKeMonHoc = thongKeMonHoc;
        this.lichNhacNho = lichNhacNho;
    }

    public List<DashboardStatDTO> getThongKeMonHoc() { return thongKeMonHoc; }
    public void setThongKeMonHoc(List<DashboardStatDTO> thongKeMonHoc) { this.thongKeMonHoc = thongKeMonHoc; }

    public List<DashboardReminderDTO> getLichNhacNho() { return lichNhacNho; }
    public void setLichNhacNho(List<DashboardReminderDTO> lichNhacNho) { this.lichNhacNho = lichNhacNho; }
}