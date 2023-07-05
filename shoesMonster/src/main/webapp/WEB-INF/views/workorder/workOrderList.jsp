<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="../include/header.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- SheetJS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<!--FileSaver [savaAs 함수 이용] -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

<style type="text/css">
.selected {
	background-color: #ccc;
}
</style>

<script type="text/javascript">
	//========================= 함수, 상수 ==================================//

	//오늘 날짜 yyyy-mm-dd
	function getToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	} //getToday()
	
	//날짜 + 시간 + 분 + 초 ==> 코드
	function codeCreation() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);
		var time = ("0" + date.getHours()).slice(-2);
		var minute = ("0" + date.getMinutes()).slice(-2);
		var second = ("0" + date.getSeconds()).slice(-2);
		
		return year + month + day + time + minute + second;
	}
	
	//input으로 바꾸기 
	function inputCng(obj, type, name, value) {
		var inputBox = "<input type='"+type+"' name='"+name+"' id='"+name+"' value='"+value+"'>";
		obj.html(inputBox);
	} //inputCng

	//팝업창 옵션
	const popupOpt = "top=60,left=140,width=600,height=600";

	//검색 팝업
	function openWindow(search, inputId) {
		var url = "/workorder/search?type=" + search + "&input=" + inputId;
		var popup = window.open(url, "", popupOpt);
	} //openWindow()
	
	

	// 팝업으로 열었을 때
	function popUp() {
		var queryString = window.location.search;
		var urlParams = new URLSearchParams(queryString);
		var isPop = urlParams.get("input");
		
		if(isPop==="null") {
			isPop = null;
		}
		
		$('#pagination a').each(function(){
			
	   		var prHref = $(this).attr("href");
	   			
   			var newHref = prHref + "&input=" + isPop;
   			$(this).attr("href", newHref);
				
		}); //페이징 요소	
		
		$('#input').val(isPop);
		
    	if(isPop!=null && isPop!="") {
			
        	$('#add').hide();
        	$('#modify').hide();
        	$('#delete').hide();
        	$('#save').hide();
        	
        	//:not(:first-child)
       		$('table tr').click(function(){
       			$(this).css('background', '#ccc');
        		
       			if(isPop==="work_code") {
       				//생산실적(performList)에서 열었을 때
	        		var workCode = $(this).find('#workCode').text();
	        		var lineCode = $(this).find('#lineCode').text();
	        		var prodCode = $(this).find('#prodCode').text();
	        		var workQt = $(this).find('#workQt').text(); 
	        		
	        		$('#'+isPop, opener.document).val(workCode);
	        		$('#line_code', opener.document).val(lineCode);
	        		$('#prod_code', opener.document).val(prodCode);
	        		
	        		//실적수량, 양품수, 불량수 작업지시량보다 많을 수 없게 설정
	        		$("input[type='number']", opener.document).attr("max", workQt);
	        		$("input[type='number']", opener.document).attr("placeholder", workQt);
	        		
       			} else {
	        		var workCode = $(this).find('#workCode').text();
	        		
	        		$('#'+isPop, opener.document).val(workCode);
       			}
        		
        		window.close();
        	}); //테이블에서 누른 행 부모창에 자동입력하고 창 닫기
        		
         		
   		} //if 
   		
   		else {
   			console.log("팝업아님");
    	} //if(팝업으로 열었을 때)
    		
	} //popUp()
	
	

	
	//========================= 함수, 상수 ==================================//
	
	//jQuery
	$(function() {
		
		//테이블 항목들 인덱스 부여
		$('table tr').each(function(index) {
			$(this).find('td:first').text(index);
		});
		
		
		popUp();			
		

		//============================ 버튼 구현 ====================================//

		/////////////// 추가 /////////////////////////////////////
		$('#add').click(function() {

			$('#modify').attr("disabled", true);
			$('#delete').attr("disabled", true);

			let today = getToday();

			if ($(this).hasClass('true')) {

				var tbl = "<tr>";
				// 번호
				tbl += " <td>";
				tbl += " </td>";
				// 작업지시코드
				tbl += " <td>";
				tbl += "  <input type='text' name='work_code' id='work_code' readonly value='";
				tbl += "WO" + codeCreation();
				tbl += "'>";
				tbl += " </td>";
				// 라인코드
				tbl += " <td>";
				tbl += "  <input type='text' name='line_code' id='line_code' required readonly>";
				tbl += " </td>";
				// 수주코드
				tbl += " <td>";
				tbl += "  <input type='text' name='order_code' id='order_code' required readonly>";
				tbl += " </td>";
				// 품번
				tbl += " <td>";
				tbl += "  <input type='text' name='prod_code' id='prod_code' required readonly>";
				tbl += " </td>";
				// 지시상태
				tbl += " <td>";
				tbl += "  <select name='work_state' id='work_state'>";
				tbl += "   <option>지시</option>";
				tbl += "   <option>진행</option>";
				tbl += "   <option>마감</option>";
				tbl += "  </select>"
				tbl += " </td>";
				// 지시일
				tbl += " <td>";
				tbl += "  <input type='text' name='work_date' id='work_date' readonly value='";
				tbl += today;
				tbl += "'>";
				tbl += " </td>";
				// 지시수량
				tbl += " <td>";
				tbl += "  <input type='text' name='work_qt' id='work_qt' required>";
				tbl += " </td>";
				tbl += "</tr>";

				$('table').append(tbl);

				//라인코드 검색
				$('#line_code').click(function() {
					openWindow("line", "line_code");
				}); //lineCode click

				//수주코드 검색
				$('#order_code').click(function() {
					openWindow("order", "order_code");
				}); //orderCode click

				$(this).removeClass('true');
			} //true 클래스 있을 때

			// 저장 -> form 제출하고 저장함
			$('#save').click(function() {

				var line_code = $('#line_code').val();
				var prod_code = $('#prod_code').val();
				var order_code = $('#order_code').val();
				var work_state = $('#work_state').val();
				var work_qt = $('#work_qt').val();

				if (line_code == "" || prod_code == "" || order_code == "" || work_state == "" || work_qt == "") {
					alert("항목을 모두 입력하세요");
				} else {
					$('#fr').attr("action", "/workorder/add");
					$('#fr').attr("method", "post");
					$('#fr').submit();
				}

			}); //save

			//취소버튼 -> 리셋
			$('#cancle').click(function() {
				$('#fr').each(function() {
					this.reset();
				});
			}); //cancle click

		}); //add click

		
		
		let queryString = window.location.search;
		let urlParams = new URLSearchParams(queryString);
		var fromController = urlParams.get("woInsert");
		
// 		console.log(fromController);
		
		if(fromController==0) {
			if(confirm("재고가 부족합니다. 발주등록 페이지로 이동하시겠습니까?")) {
				location.href = "/stock/raw_order";
			}
		}
		
		
		var isExecuted = false;
		/////////////// 수정 //////////////////////////////
		//수정버튼 클릭
		$('#modify').click(function() {

			$('#add').attr("disabled", true);
			$('#delete').attr("disabled", true);

			//행 하나 클릭했을 때	
			//:not(:first-child)
			$('table tr').click(function() {

				//하나씩만 선택 가능
				if(!isExecuted) {
					isExecuted = true;
					
					$(this).addClass('selected');
					//작업지시 코드 저장
					let updateCode = $(this).find('#workCode').text().trim();
					console.log(updateCode);
	
					var jsonData = {
						work_code : updateCode
					};
	
					var self = $(this);
	
					$.ajax({
						url : "/workorder/detail",
						type : "post",
						contentType : "application/json; charset=UTF-8",
						dataType : "json",
						data : JSON.stringify(jsonData),
						success : function(data) {
							// alert("*** 아작스 성공 ***");
	
							var preVOs = [
									data.work_code,
									data.line_code,
									data.order_code,
									data.prod_code,
									data.work_state,
									data.work_date,
									data.work_qt
								];
	
							var names = [
									"work_code",
									"line_code",
									"order_code",
									"prod_code",
									"work_state",
									"work_date",
									"work_qt" 
								];
	
							//tr안의 td 요소들 input으로 바꾸고 기존 값 띄우기
							self.find('td').each(function(idx,item) {
	
								if (idx > 0) {
									inputCng($(this),"text",names[idx - 1],preVOs[idx - 1]);
									if (idx == 5) {
										var dropDown = "<select id='work_state' name='work_state'>";
										dropDown += "<option value='지시'>지시</option>";
										dropDown += "<option value='진행'>진행</option>";
										dropDown += "<option value='마감'>마감</option>";
										dropDown += "</select>";
										$(this).html(dropDown);
										$(this).find('option').each(function() {
											if (this.value == preVOs[idx - 1]) {
												$(this).attr("selected",true);
											}
										}); //option이 work_state와 일치하면 선택된 상태로
									} //지시상태 - select
									
									//지시수량 제외하고 readonly 속성 부여
									$(this).find("input").each(function(){
										if($(this).attr("name") != "work_qt") {
											$(this).attr("readonly", true);
										}
									}); //readonly
									
								} //라인코드부터 다 수정 가능하게
								
							}); // self.find(~~)
	
							//라인코드 검색
							$('#line_code').click(function() {
								openWindow("line","line_code");
							}); //lineCode click
	
							//수주코드 검색
							$('#order_code').click(function() {
								openWindow("order","order_code");
							}); //orderCode click
	
						},
						error : function(data) {
							alert("아작스 실패 ~~");
						}
					}); //ajax
	
					//저장버튼 -> form 제출
					$('#save').click(function() {
	
						$('#fr').attr("action","/workorder/modify");
						$('#fr').attr("method","post");
						$('#fr').submit();
	
					}); //save

				} //하나씩만 선택 가능
					
					
				//취소버튼 -> 리셋
				$('#cancle').click(function() {
					$('#fr').each(function() {
						this.reset();
					});
				}); //cancle click

			}); //tr click

		}); //modify click

		
		queryString = window.location.search;
		urlParams = new URLSearchParams(queryString);
		var fromController = urlParams.get("woModify");
		
// 		console.log(fromController);
		
		if(fromController==0) {
			if(confirm("재고가 부족합니다. 발주등록 페이지로 이동하시겠습니까?")) {
				location.href = "/stock/raw_order";
			}
		}
		
		
		/////////////// 삭제 //////////////////////////////
		$('#delete').click(function() {

			$('#add').attr("disabled", true);
			$('#modify').attr("disabled", true);
	
			if($(this).hasClass('true')) {
				
				// td 요소 중 첫번째 열 체크박스로 바꾸고 해당 행의 작업 지시 코드 저장
				$('table tr').each(function() {
					var code = $(this).find('td:nth-child(2)').text();
	
					var tbl = "<input type='checkbox' name='selected' value='";
					tbl += code;
					tbl += "'>";
					
// 					var thTmp = "<div class='icheckbox_flat-green' style='position: relative;'>";
// 					thTmp += "<input type='checkbox' id='check-all' class='flat' style='position: absolute; opacity: 0;'>";
// // 					thTmp += "<ins class='iCheck-helper' style='position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;''></ins>";
// 					thTmp += "</div>";
					
// 					var tdTmp = "<div class='icheckbox_flat-green' style='position: relative;'>";
// 					tdTmp += "<input type='checkbox' class='flat' name='table_records' style='position: absolute; opacity: 0;' value='";
// 					tdTmp += code;
// 					tdTmp += "'>";
// // 					tdTmp += "<ins class='iCheck-helper' style='position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;'></ins>";
// 					tdTmp += "</div>";
					
					$(this).find('th:first').html("<input type='checkbox' id='selectAll'>");
					$(this).find('td:first').html(tbl);
// 					$(this).find('th:first').html(thTmp);
// 					$(this).find('td:first').html(tdTmp);
				});
				
				//전체선택
				$('#selectAll').click(function() {
// 				$('d.icheckbox_flat-green #check-all').click(function() {
					var checkAll = $(this).is(":checked");
					
// 					console.log("check-all checked?? " + checkAll);
					
					if (checkAll) {
						$('input:checkbox').prop('checked', true);
					} else {
						$('input:checkbox').prop('checked', false);
					}
				});
	
				//저장 -> 삭제
				$('#save').click(function() {
	
					var checked = [];
	
					$('input[name=selected]:checked').each(function() {
// 					$('input[name=table_records]:checked').each(function() {
						console.log("check => " + $(this).val());
						checked.push($(this).val());
					});
	
// 					console.log(checked);
	
					if (checked.length > 0) {
	
						$.ajax({
							url : "/workorder/delete",
							type : "post",
							data : {checked : checked},
							dataType : "text",
							success : function() {
								alert("*** 아작스 성공 ***");
								location.reload();
							},
							error : function() {
								alert("아작스실패~~");
							}
						}); //ajax
	
					} //체크된거 있을대
					else {
						alert("선택된 항목이 없습니다.");
					} //체크된거 없을때
	
				}); //save
				
				$(this).removeClass('true');
			} //if(삭제 버튼 true class 있으면)

			//취소 -> 리셋
			$('#cancle').click(function() {
				$('input:checkbox').prop('checked', false);
			});

		}); //delete click

		//============================ 버튼 구현 ====================================//

		//============================ 검색 =========================================//

		//라인코드 검색 팝업
		$('#search_line').click(function() {
			openWindow("line", "search_line");
		}); //lineCode click

		//품번 검색 팝업
		$('#search_prod').click(function() {
			openWindow("prod", "search_prod");
		}); //prodCode click

		//지시일자 이날부터
		$('#search_fromDate').datepicker({
			showOn:'both',
			buttonImage:'http://jqueryui.com/resources/demos/datepicker/images/calendar.gif',
			buttonImageOnly:'true',
			changeMonth:'true',
			changeYear:'true',
			nextText:'다음달',
			prevText:'이전달',
			showButtonPanel:'true',
			currentText:'오늘',
			closeText:'닫기',
			dateFormat:'yy-mm-dd',
			dayNames:['월요일','화요일','수요일','목요일','금요일','토요일','일요일'],
			dayNamesMin:['월','화','수','목','금','토','일'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			onSelect: function(date, inst) {
				$('#search_toDate').datepicker('option', 'minDate', $(this).datepicker('getDate'));
			}
		});
		
		//이날까지
		$('#search_toDate').datepicker({
			showOn:'both',
			buttonImage:'http://jqueryui.com/resources/demos/datepicker/images/calendar.gif',
			buttonImageOnly:'true',
			changeMonth:'true',
			changeYear:'true',
			nextText:'다음달',
			prevText:'이전달',
			showButtonPanel:'true',
			currentText:'오늘',
			closeText:'닫기',
			dateFormat:'yy-mm-dd',
			dayNames:['월요일','화요일','수요일','목요일','금요일','토요일','일요일'],
			dayNamesMin:['월','화','수','목','금','토','일'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
		
		
		//검색 결과 없을 때 표, 버튼 다 숨기기
		if(Number($('#total').text())==0) {
			$('#body').html("검색 결과가 없습니다.");
		}
		
		//============================ 검색 =========================================//
		
		
		
		//n건씩 표시
		$('#perPage').on('change', function() {
			var pageSize = $(this).val();
			$('#pageSize').val(pageSize);
			
			var queryString = window.location.search;
			var urlParams = new URLSearchParams(queryString);
			var isPop = urlParams.get("search_state");
			$('#search_state').val(isPop);
			
			$('#searchForm').submit();
		});
		
		$('#perPage').find('option').each(function(){
			if($(this).val()===$('#pageSize').val()) {
				$(this).prop("selected", true);
			}
		});
		//n건씩 표시
		
		
		//작업지시코드 클릭시 상세조회
		$('#workCode a').click(function() {
			var obj = { work_code:$(this).text().trim() };
				
			$.ajax({
				url : "/workorder/detail",
				type : "post",
				contentType : "application/json; charset=UTF-8",
				dataType : "json",
				data : JSON.stringify(obj),
				success : function(data) {
					console.log(data);
					
					var tmp = "작업지시코드: ";
					tmp += data.work_code;
					tmp += " 라인코드: ";
					tmp += data.line_code;
					tmp += " 수주코드: ";
					tmp += data.order_code;
					tmp += " 품번: ";
					tmp += data.prod_code;
					tmp += "<br>지시상태: ";
					tmp += data.work_state;
					tmp += " 지시일: ";
					tmp += data.work_date;
					tmp += " 지시수량: ";
					tmp += data.work_qt;
					tmp += "<br>등록자: ";
					tmp += ((data.emp_id===""||data.emp_id==null) ? "없음" : data.emp_id);
					tmp += " 변경자: ";
					tmp += ((data.change_id===""||data.change_id==null) ? "없음" : data.change_id);
					tmp += " 변경일: ";
					tmp += ((data.change_date===""||data.change_date==null) ? "없음" : data.change_date);
					tmp += " 비고: ";
					tmp += ((data.work_note===""||data.work_note==null) ? "없음" : data.work_note);
					
					$('#detail').html(tmp);
				},
				error: function() {
					console.log("아작스 실패");
				}
			}); //ajax
				
		}); //작업지시코드 클릭
		
		
	}); //jQuery
	
</script>

<!-- page content -->
<div class="right_col" role="main">
	<h1>작업지시 관리</h1>

	
	
	
	
	
	
	
<!-- 	<div class="col-md-12 col-sm-12 "> -->
<!-- 		<div class="x_panel"> -->
<!-- 		<div class="x_title"> -->
<!-- 			<h2>Form Design <small>different form elements</small></h2> -->
<!-- 				<ul class="nav navbar-right panel_toolbox"> -->
<!-- 					<li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a> -->
<!-- 					</li> -->
<!-- 					<li class="dropdown"> -->
<!-- 						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-wrench"></i></a> -->
<!-- 						<ul class="dropdown-menu" role="menu"> -->
<!-- 							<li><a class="dropdown-item" href="#">Settings 1</a> -->
<!-- 							</li> -->
<!-- 							<li><a class="dropdown-item" href="#">Settings 2</a> -->
<!-- 							</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 					<li><a class="close-link"><i class="fa fa-close"></i></a> -->
<!-- 					</li> -->
<!-- 				</ul> -->
<!-- 			<div class="clearfix"></div> -->
<!-- 		</div> -->
<!-- 			<div class="x_content"> -->
<!-- 			<br> -->
<!-- 				<form id="demo-form2" data-parsley-validate="" class="form-horizontal form-label-left" novalidate=""> -->
<!-- 				<div class="item form-group"> -->
<!-- 					<label class="col-form-label col-md-3 col-sm-3 label-align" for="first-name"> 라인코드 </label> -->
<!-- 					<div class="col-md-6 col-sm-6 "> -->
<!-- 						<input type="text" id="first-name" required="required" class="form-control "> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div class="item form-group"> -->
<!-- 					<label class="col-form-label col-md-3 col-sm-3 label-align"> 지시일자 </label> -->
<!-- 					<div class="col-md-6 col-sm-6 "> -->
<!-- 						<input id="birthday" class="date-picker form-control" placeholder="dd-mm-yyyy" type="text" required="required" onfocus="this.type='date'" onmouseover="this.type='date'" onclick="this.type='date'" onblur="this.type='text'" onmouseout="timeFunctionLong(this)"> -->
<!-- 						<script> -->
<!-- // 							function timeFunctionLong(input) { -->
<!-- // 								setTimeout(function() { -->
<!-- // 									input.type = 'text'; -->
<!-- // 								}, 60000); -->
<!-- // 							} -->
<!-- 						</script> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div class="item form-group"> -->
<!-- 					<label for="middle-name" class="col-form-label col-md-3 col-sm-3 label-align"> 품번 </label> -->
<!-- 					<div class="col-md-6 col-sm-6 "> -->
<!-- 						<input id="middle-name" class="form-control" type="text" name="middle-name"> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div class="item form-group"> -->
<!-- 					<label class="col-form-label col-md-3 col-sm-3 label-align"> 지시상태 </label> -->
<!-- 					<div class="col-md-6 col-sm-6 "> -->
<!-- 						<p> -->
<!-- 							M: -->
<!-- 							<div class="iradio_flat-green checked" style="position: relative;"> -->
<!-- 								<input type="radio" class="flat" name="gender" id="genderM" value="M" checked="" required="" data-parsley-multiple="gender" style="position: absolute; opacity: 0;"> -->
<!-- 								<ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins> -->
<!-- 							</div>  -->
<!-- 							F: -->
<!-- 							<div class="iradio_flat-green" style="position: relative;"> -->
<!-- 								<input type="radio" class="flat" name="gender" id="genderF" value="F" data-parsley-multiple="gender" style="position: absolute; opacity: 0;"> -->
<!-- 								<ins class="iCheck-helper" style="position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;"></ins> -->
<!-- 							</div> -->
<!-- 						</p> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div class="ln_solid"></div> -->
<!-- 					<div class="item form-group"> -->
<!-- 						<div class="col-md-6 col-sm-6 offset-md-3"> -->
<!-- 							<button class="btn btn-primary" type="button">Cancel</button> -->
<!-- 							<button class="btn btn-primary" type="reset">Reset</button> -->
<!-- 							<button type="submit" class="btn btn-success">Submit</button> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 				</form> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<div>
		<form id="searchForm" method="get">
			<fieldset>
				<input type="hidden" name="input" id="input" value="${input }">
				<input type="hidden" name="pageSize" id="pageSize" value="${pm.lwPageVO.pageSize }">
				<span>라인코드:</span> <input type="text" name="search_line" id="search_line" class="searchInputText"> 
				<span>지시일자:</span> 
					<input type="text" name="search_fromDate" id="search_fromDate" class="searchInputText"> ~ 
					<input type="text" name="search_toDate" id="search_toDate" class="searchInputText"> 
				<br>
				<span>지시상태:</span> 
					<input type="radio" name="search_state" id="search_state" class="searchRadio" value="전체" checked> 전체 
					<input type="radio" name="search_state" id="search_state" class="searchRadio" value="지시"> 지시 
					<input type="radio" name="search_state" id="search_state" class="searchRadio" value="진행"> 진행 
					<input type="radio" name="search_state" id="search_state" class="searchRadio" value="마감"> 마감 
				<span>품번:</span> <input type="text" name="search_prod" id="search_prod" class="searchInputText">
				<br>
				<input type="submit" value="조회"> 
			</fieldset>
		</form>
	</div>

	<br><br>
	
	
		<button id="add" class="true">추가</button>
		<button id="modify">수정</button>
		<button id="delete" class="true">삭제</button>
		<button type="reset" id="cancle">취소</button>
		<button type="submit" id="save">저장</button>
		
	<div id="body">
	
		총 <span id="total">${pm.totalCount }</span>건
		
		<select id="perPage" name="perPage">
			<option value="2">2</option>
			<option value="5">5</option>
			<option value="7">7</option>
		</select>
		건씩 표시
	</div>
		
	<div class="table-responsive">
		<form id="fr">
			<table border="1" class="table table-striped jambo_table bulk_action"  id="data-table">
				<thead>
					<tr class="headings">
						<th class="column-title">번호</th>
						<th class="column-title">작업지시코드</th>
						<th class="column-title">라인코드</th>
						<th class="column-title">수주코드</th>
						<th class="column-title">품번</th>
						<th class="column-title">지시상태</th>
						<th class="column-title">지시일</th>
						<th class="column-title">지시수량</th>
					</tr>
				</thead>
				<c:forEach var="w" items="${workList }">
					<tr class="even pointer">
						<td class="a-center"></td>
						<td id="workCode"><a href="#" onclick="return false">${w.work_code }</a></td>
						<td id="lineCode">${w.line_code }</td>
						<td>${w.order_code }</td>
						<td id="prodCode">${w.prod_code }</td>
						<td>${w.work_state }</td>
						<td>${w.work_date }</td>
						<td id="workQt">${w.work_qt }</td>
					</tr>
				</c:forEach>
			</table>
		</form>
	</div>
	
	<button id="excelDownload">엑셀다운로드</button>
		
	<script type="text/javascript">
		
		//엑셀
		const excelDownload = document.querySelector('#excelDownload');
		
		document.addEventListener('DOMContentLoaded', ()=> {
			excelDownload.addEventListener('click', exportExcel);
		});
		
		function exportExcel() {
			//1. workbook 생성
			var wb = XLSX.utils.book_new();
			
			//2. 시트 만들기
			var newWorksheet = excelHandler.getWorksheet();
			
			//3. workbook에 새로 만든 워크시트에 이름을 주고 붙이기
			XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());
			
			//4. 엑셀 파일 만들기
			var wbout = XLSX.write(wb, {bookType:'xlsx', type:'binary'});
			
			//5. 엑셀 파일 내보내기
			saveAs(new Blob([s2ab(wbout)], {type:"application/octet-stream"}), excelHandler.getExcelFileName());
			
		} //exportExcel()
		
		var excelHandler = {
			getExcelFileName : function() {
				return 'workOrderList'+getToday()+'.xlsx'; //파일명
			},
			getSheetName : function() {
				return 'Work Order Sheet'; //시트명
			},
			getExcelData : function() {
				return document.getElementById('data-table'); //table id
			},
			getWorksheet : function() {
				return XLSX.utils.table_to_sheet(this.getExcelData());
			}
		} //excelHandler
		
		function s2ab(s) {
			var buf = new ArrayBuffer(s.length);  // s -> arrayBuffer
			var view = new Uint8Array(buf);  
			for(var i=0; i<s.length; i++) {
				view[i] = s.charCodeAt(i) & 0xFF;
			}
			return buf;
		} //s2ab(s)
		
	</script>
		
		
		
		<div id="pagination">
			<c:if test="${pm.prev }">
				<a href="/workorder/workOrderList?page=${pm.startPage - 1 }&pageSize=${pm.lwPageVO.pageSize }&search_line=${search.search_line}&search_fromDate=${search.search_fromDate}&search_toDate=${search.search_toDate}&search_state=${search.search_state}&search_prod=${search.search_prod}"> ⏪ </a>
			</c:if>
			
			<c:forEach var="page" begin="${pm.startPage }" end="${pm.endPage }" step="1">
				<a href="/workorder/workOrderList?page=${page }&pageSize=${pm.lwPageVO.pageSize }&search_line=${search.search_line}&search_fromDate=${search.search_fromDate}&search_toDate=${search.search_toDate}&search_state=${search.search_state}&search_prod=${search.search_prod}">${page }</a>
			</c:forEach>
	
			<c:if test="${pm.next }">
				<a href="/workorder/workOrderList?page=${pm.endPage + 1 }&pageSize=${pm.lwPageVO.pageSize }&search_line=${search.search_line}&search_fromDate=${search.search_fromDate}&search_toDate=${search.search_toDate}&search_state=${search.search_state}&search_prod=${search.search_prod}"> ⏩ </a>
			</c:if>
		</div>

	<div id="detail"></div>
	
	
</div>
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/forTest/workOrderList.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
