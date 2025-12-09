package com.example.lms_backend.service; // <--- DÒNG NÀY RẤT QUAN TRỌNG

import com.example.lms_backend.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Service
public class DashboardService { // <--- Tên class phải khớp tên file DashboardService.java

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public DashboardResponse getDashboardData(String inputId) {
        return jdbcTemplate.execute((Connection conn) -> {
            CallableStatement cs = conn.prepareCall("{call Testing.sp_ThongKeDashboard_TongHop(?)}");
            cs.setString(1, inputId);
            
            boolean hasResults = cs.execute();
            DashboardResponse response = new DashboardResponse();
            response.setThongKeMonHoc(new ArrayList<>());
            response.setLichNhacNho(new ArrayList<>());

            int tableIndex = 0;

            while (true) {
                if (hasResults) {
                    try (ResultSet rs = cs.getResultSet()) {
                        if (tableIndex == 0) {
                            List<DashboardStatDTO> stats = new ArrayList<>();
                            while (rs.next()) {
                                DashboardStatDTO dto = new DashboardStatDTO();
                                dto.setMaMonHoc(rs.getString("MaMonHoc"));
                                dto.setTenMonHoc(rs.getString("TenMonHoc"));
                                dto.setTongSoBai(rs.getInt("TongSoBaiKiemTra"));
                                dto.setSoBaiDaLam(rs.getInt("SoBaiDaLam"));
                                dto.setDiemTrungBinh(rs.getDouble("DiemTrungBinhMon"));
                                dto.setDiemCaoNhat(rs.getDouble("DiemCaoNhatMon"));
                                stats.add(dto);
                            }
                            response.setThongKeMonHoc(stats);
                        } else if (tableIndex == 1) {
                            List<DashboardReminderDTO> reminders = new ArrayList<>();
                            while (rs.next()) {
                                DashboardReminderDTO dto = new DashboardReminderDTO();
                                dto.setTenBaiKiemTra(rs.getString("TenBaiKiemTra"));
                                dto.setTenMonHoc(rs.getString("TenMonHoc"));
                                dto.setHanChotNopBai(rs.getTimestamp("HanChotNopBai"));
                                dto.setSoGioConLai(rs.getInt("SoGioConLai"));
                                dto.setTrangThai(rs.getString("TrangThai"));
                                reminders.add(dto);
                            }
                            response.setLichNhacNho(reminders);
                        }
                        tableIndex++;
                    }
                } else {
                    if (cs.getUpdateCount() == -1) break;
                }
                hasResults = cs.getMoreResults();
            }
            return response;
        });
    }
}