	package com.sm.domain.b;

import java.sql.Date;

import lombok.Data;

@Data
public class Raw_orderVO {

	private String raw_order_num;
	private String raw_code;
	private String client_code;
	private String emp_id;
	private int raw_order_count;
	private Date raw_order_date;
			
}
