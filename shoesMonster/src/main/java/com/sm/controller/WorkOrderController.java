package com.sm.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sm.domain.WorkOrderVO;
import com.sm.service.PerformanceService;
import com.sm.service.WorkOrderService;

@Controller
@RequestMapping(value = "/workorder/*")
public class WorkOrderController {
	private static final Logger logger = LoggerFactory.getLogger(WorkOrderController.class);
	
	@Autowired
	private WorkOrderService wService;
	
	@Autowired
	private PerformanceService pService;
	
	//작업지시 목록
	//http://localhost:8088/workorder/workOrderList
	@RequestMapping(value = "/workOrderList", method = RequestMethod.GET)
	public void workOrderListGET(Model model) throws Exception {
		logger.debug("@@@@@ CONTROLLER: workOrderListGET() 호출");
		
		List<WorkOrderVO> workList = wService.getAllWorkOrder();
		
		model.addAttribute("workList", workList);
		
	} //workOrderListGET()
	
	//라인, 품목, 수주 검색
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String lineGET(Model model, @RequestParam("type") String type) throws Exception {
		logger.debug("@@@@@ CONTROLLER: lineGET() 호출");
		logger.debug("@@@@@ CONTROLLER: type = " + type);
		
		if(type.equals("line")) {
			model.addAttribute("lineList", pService.getLineList());
			return "/workorder/lineSearch";
		}
		
		else if(type.equals("prod")) {
			model.addAttribute("prodList", pService.getProdList());
			return "/workorder/prodSearch";
		}
		
		else /* if(type.equals("order"))*/ {
			
			/////// 수주 리스트 메서드 아직 없음 만들면 추가하기 ////////
			
			model.addAttribute("prodList", pService.getProdList());
			return "/workorder/orderSearch";
		}
		
//		return "";
	} //lineGET()
	
	//작업지시 추가
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public String addWorkOrder(@RequestBody WorkOrderVO vo) throws Exception {
		logger.debug("@@@@@ CONTROLLER: addWorkOrder() 호출");
		logger.debug("@@@@@ CONTROLLER: vo = " + vo);
		
		//서비스 - 작업지시 등록
		wService.regWorkOrder(vo);
		
		return "redirect:/workorder/workOrderList";
	} //addWorkOrder()
	
	//작업지시 삭제
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String deleteWorkOrder(@RequestParam(value="checked[]") List<String> checked) throws Exception {
		logger.debug("@@@@@ CONTROLLER: deleteWorkOrder() 호출");
		logger.debug("@@@@@ CONTROLLER: checked = " + checked);
		
		//서비스 - 작업지시 삭제 
		wService.removeWorkOrder(checked);
		
		return "redirect:/workorder/workOrderList";
	} //deleteWorkOrder()
	
	
	
	
	
	
	
	
	
	
} //WorkOrderController
