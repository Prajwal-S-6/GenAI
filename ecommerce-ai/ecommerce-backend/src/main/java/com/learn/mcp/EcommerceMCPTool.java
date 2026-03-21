package com.learn.mcp;

import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class EcommerceMCPTool {

    private final JdbcTemplate jdbcTemplate;

    public EcommerceMCPTool(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Tool
    public String topSellingProducts(
            @ToolParam(description = "How many products to return. eg 5 or 10") int limit,
            @ToolParam(description = "Sort by revenue or units") String sortBy
    ) {
        String col = "revenue".equalsIgnoreCase(sortBy) ? "total_revenue": "total_units_sold";
        List<Map<String,Object>> rows = jdbcTemplate.queryForList("""
            SELECT name, category, price,
                   total_units_sold, total_revenue, total_profit
            FROM product_sales_summary
            WHERE total_units_sold > 0
            ORDER BY ? DESC
            LIMIT ?
            """, col, limit < 1 ? 10 : limit);

        if(rows.isEmpty()) return "No Sales data.";

        StringBuilder sb = new StringBuilder("Top selling products:\n");
        int rank = 1;
        for (Map<String,Object> r : rows) {
            sb.append(String.format(
                    "%d. %s [%s] — %s units | ₹%,.0f revenue | ₹%,.0f profit\n",
                    rank++, r.get("name"), r.get("category"),
                    r.get("total_units_sold"),
                    ((Number) r.get("total_revenue")).floatValue(),
                    ((Number) r.get("total_profit")).floatValue()));
        }
        return sb.toString();

    }
}
