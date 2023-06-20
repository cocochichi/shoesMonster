package com.sm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sm.domain.In_materialVO;
import com.sm.domain.Raw_orderVO;
import com.sm.service.In_materialService;
import com.sm.service.Raw_orderService;

@Controller
@RequestMapping(value = "/stock/*")
public class stockController {
	
	@Autowired
	private In_materialService service;
	
	@Autowired
	private Raw_orderService ro_service;
	
	private static final Logger logger = LoggerFactory.getLogger(stockController.class);
	

	
	// 발주 목록 + 페이징 처리 - 시작
    // http://localhost:8080/stock/raw_order
	// http://localhost:8088/stock/raw_order
	@RequestMapping(value="/raw_order", method = RequestMethod.GET)
    public void getListPage(HttpServletRequest request, Model model) throws Exception {
        
         // 게시물 총 개수
         int count1 = ro_service.count1();
         
         // 한 페이지에 출력할 게시물 개수
         int pageSize = 1;
         
         String pageNum = request.getParameter("num");
         if(pageNum == null) {
        	 pageNum = "1";
         }
         
         // 행번호
         int currentPage = Integer.parseInt(pageNum);
         int startRow = (currentPage - 1) * pageSize;
         
         // 페이징 처리 - 하단
 		 int pageCount = count1/pageSize + (count1%pageSize == 0? 0 : 1);
 		 int pageBlock = 1;

 		 // 페이지 번호
 		 int startPage = ((currentPage-1)/pageBlock)*pageBlock + 1;
 		 int endPage = startPage+pageBlock-1;
 		 if(endPage > pageCount) {
 			 endPage = pageCount;
 		 } 
         
         List<Raw_orderVO> ro_List = ro_service.getRaw_order(startRow, pageSize);
        
         model.addAttribute("ro_List", ro_List);
         model.addAttribute("startPage", startPage);
         model.addAttribute("endPage", endPage);
         model.addAttribute("pageBlock", pageBlock);
         model.addAttribute("count1",count1);
    }
	// 발주 목록 + 페이징 처리 - 끝
	
	
	
    

	
	
	// 입고 페이징
    //http://localhost:8088/stock/In_material?num=1
  	//http://localhost:8080/stock/In_material?num=1
    @RequestMapping(value = "/In_material",	method = RequestMethod.GET)
    public void In_matPage(Model model, @RequestParam("num") int num ,
    		@RequestParam(value = "searchType" ,required = false, defaultValue = "title") String searchType 
    		, @RequestParam(value = "keyword" , required = false , defaultValue="") String keyword) throws Exception {
        
    	
    	// 게시물 총 갯수
        int count = service.count();

        // 한 페이지 출력 갯수
        int postNum = 5;

        // 하단 페이지 번호
        int pageNum = (int) Math.ceil((double) count / postNum);

        // 출력 게시물
        int displayPost = (num - 1) * postNum;

        // 한번에 표시할 페이징 번호의 갯수
        int pageNum_cnt = 10;

        // 표시되는 페이지 번호 중 첫번째 번호
        int startPageNum = (int) (Math.ceil((double) num / pageNum_cnt) * pageNum_cnt) - pageNum_cnt + 1;

        // 표시되는 페이지 번호 중 마지막 번호
        int endPageNum = startPageNum + pageNum_cnt - 1;
        if (endPageNum > pageNum) {
            endPageNum = pageNum;
        }

        // 이전 및 다음
        boolean prev = startPageNum != 1;
        boolean next = endPageNum != pageNum;
    
        
        List<In_materialVO> In_materialList = service.getIn_matPage(displayPost, postNum ,searchType, keyword);
        
        
        model.addAttribute("In_materialList", In_materialList);
        model.addAttribute("pageNum", pageNum);
        
        // 시작 및 끝 번호
        model.addAttribute("startPageNum", startPageNum);
        model.addAttribute("endPageNum", endPageNum);

        // 이전 및 다음 
        model.addAttribute("prev", prev);
        model.addAttribute("next", next);
        
        // 현재 페이지
        model.addAttribute("select",num);
    }
    // 입고 페이징
}
