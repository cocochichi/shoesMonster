<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>

<%@ include file="../include/header.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<!-- 폰트 -->
<link href="https://webfontworld.github.io/NexonLv2Gothic/NexonLv2Gothic.css" rel="stylesheet">

<style type="text/css">

body {
	font-family: 'NexonLv2Gothic';
}
</style>
<!-- 폰트 -->

<script type="text/javascript">
//========================================= 함수, 상수 ===================================================	
//날짜 + 시간 + 분 + 초 ==> 코드
function codeCreation() {

	Date.prototype.getYearYY = function(){
        var a = this.getYear();
        return a >= 100 ? a-100 : a;
      }

    var date = new Date();
    var YY_year = date.getYearYY();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);
    var time = ("0" + date.getHours()).slice(-2);
    var minute = ("0" + date.getMinutes()).slice(-2);
    var second = ("0" + date.getSeconds()).slice(-2);

    return year + month + day + time + minute + second;
}

// input으로 바꾸기
function inputCng(obj, type, name, value) {
	var inputBox = "<input type='"+type+"' name='"+name+"' id='"+name+"' value='"+value+"'>";
	obj.html(inputBox);
}// inputCng
	
	
//오늘 날짜 yyyy-mm-dd
function getToday() {
	var date = new Date();
	var year = date.getFullYear();
	var month = ("0" + (1 + date.getMonth())).slice(-2);
	var day = ("0" + date.getDate()).slice(-2);

	return year + "-" + month + "-" + day;
} //getToday()

// 팝업 옵션
const popupOpt = "top=60,left=140,width=600,height=600";

//검색 팝업
function openWindow(search, inputId) {
 	var url = "/workorder/search?type=" + search + "&input=" + inputId;
 	var popup = window.open(url, "", popupOpt);
} //openWindow()
   

// 거래처 검색 
function serchClient(inputId){
  	openWindow("client",inputId);
}

// 완제품 검색
function serchProd(inputId){
  	openWindow("prod",inputId);
}

// 담당자 검색
function serchEmp(inputId){
  	openWindow("emp",inputId);
}
	

//검색 팝업2
function openWindow2(search, inputId) {
	var url = "/person/search?type=" + search + "&input=" + inputId;
	var popup = window.open(url, "", popupOpt);
} //openWindow2()


function popUp() {
	var queryString = window.location.search;
	var urlParams = new URLSearchParams(queryString);
	
	var isPop = urlParams.get("input");
	
	if(isPop==="null") {
		isPop = null;
	}
	
	// vvvvvvvvvvvvvvvvvv 페이징 완료하면 주석 풀기 ~~ vvvvvvvvvvvvvvvvvvvvv
	$('#pagination a').each(function(){
		
   		var prHref = $(this).attr("href");
   		
   		var newHref = prHref + "&input=" + isPop;
   			$(this).attr("href", newHref);
			
	}); //페이징 요소

	$('#input').val(isPop);
			
		if(isPop!=null && isPop!="") {
    		
    	$('#addButton').hide();
    	$('#modify').hide();
    	$('#delete').hide();
    	$('#save').hide();
    	
   		$('table tr').click(function(){
   			$(this).css('background', '#ccc');
    			
   			if(isPop === "order_code") {
   				
   				var orderCode = $(this).find('#l_orderCode').text();
   				var clientCode = $(this).find('#l_clientCode').text();
   				var clientName = $(this).find('#clientName').text();
   				var empName = $(this).find('#L_empName').text();
   				var prodCode = $(this).find('#l_prodCode').text();
   				
   				$('#'+isPop, opener.document).val(orderCode);
        		$('#client_code', opener.document).val(clientCode);
        		$('#client_Name', opener.document).val(clientName);
        		$('#emp_name', opener.document).val(empName);
        		
        		
   			} else {
    			var orderCode = $(this).find('#l_orderCode').text();
   				var prodCode = $(this).find('#l_prodCode').text();
    		
    			$('#'+isPop, opener.document).val(orderCode);
    			$('#prod_code', opener.document).val(prodCode);
			}
     			
     		window.close();
     	}); //테이블에서 누른 행 부모창에 자동입력하고 창 닫기

	}

	else {
		console.log("팝업아님");
	} //if(팝업으로 열었을 때)
		
} //popUp()


	
// ========================================= 등록 ===================================================	
$(function(){
	
	//테이블 항목들 인덱스 부여
	$('table tr').each(function(index) {
		$(this).find('td:first').text(index);
	});
	
	popUp();
	
	//----------- 추가 버튼 ----------
	$('#add').click(function () {
		$('#modify').attr("disabled", true);
		$('#delete').attr("disabled", true);
		
		let today = getToday();
		let date = codeCreation();
		
		if($(this).hasClass('true')){

			var tbl = "<tr>";
			// 번호
			tbl += "<td>";
			tbl += "</td>";
			// 수주번호
			tbl += "<td>";
			tbl += "<input type='text' name='order_code' id='order_code' readonly value='";
			tbl += 'O' + date;
			tbl += "'>";
			tbl += "</td>";
			// 수주업체코드
			tbl += "<td>";
			tbl += '<input type="text" name="client_code" id="client_code" onclick=serchClient("client_code"); required readonly>';
			tbl += "</td>";
			// 수주업체명
			tbl += "<td>";
			tbl += "<input type='text' name='client_actname' id='client_actname' onclick=serchClient('client_code'); required>";
			tbl += "</td>";
			// 수주일자
			tbl += "<td>";
			tbl += "<input type='text' name='order_date' id='order_date' required>";
			tbl += "</td>";
			// 담당자 코드 히든
			tbl += "<input type='hidden' name='emp_id' id='emp_id' required readonly>";
			// 담당자
			tbl += "<td>";
			tbl += "<input type='text' name='emp_name' id='emp_name' onclick=serchEmp('emp_id'); required readonly>";
			tbl += "</td>";
			// 품번
			tbl += "<td>";
			tbl += "<input type='text' name='prod_code' id='prod_code' onclick=serchProd('prod_code'); required readonly>";
			tbl += "</td>";
			// 품명
			tbl += "<td>";
			tbl += "<input type='text' name='prod_name' id='prod_name' onclick=serchProd('prod_code'); required>";
			tbl += "</td>";
			// 단위
			tbl += "<td>";
			tbl += "<input type='text' name='prod_unit' id='prod_unit' onclick='serchEmp('prod_code')' required>";
			tbl += "</td>";
			// 납품예정일
			tbl += "<td>";
			tbl += "<input type='text' name='order_deliveryDate' id='order_deliveryDate' required>";
			tbl += "</td>";
			// 수주량
			tbl += "<td>";
			tbl += "<input type='text' name='order_count' id='order_count' required>";
			tbl += "</td>";
			tbl += "</tr>";
			
			$('table').append(tbl);
			
			
			// 수주일자
			$('#order_date').datepicker({
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
			});
			// 납품예정일
			$('#order_deliveryDate').datepicker({
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
			});
			
			
			$(this).removeClass('true');
		}// true 클래스 있을 때
		
		// (등록)저장
		$('#save').click(function () {
			
			var order_code = $('#order_code').val();
			var client_code = $('#client_code').val();
			var client_actname = $('#client_actname').val();
			var order_date = $('#order_date').val();
			var emp_name = $('#emp_name').val();
			var prod_code = $('#prod_code').val();
			var prod_name = $('#prod_name').val();
			var prod_unit = $('#prod_unit').val();
			var order_deliveryDate = $('#order_deliveryDate').val();
			var order_count = $('#order_count').val();
			
			if(order_code == "" || client_code == "" || order_date == "" ||
			   emp_name == "" || prod_code == "" || prod_name == "" || prod_unit == "" 
			   || order_deliveryDate== "" || order_count == "" ){
				alert("항목을 모두 입력하세요");
			}else{
				$('#fr').attr("action", "/person/addOrder");
				$('#fr').attr("method", "POST");
				$('#fr').submit();
			}
		});//save.click
		
		// 취소버튼(=리셋)
		$('#cancle').click(function () {
			$('#fr').each(function () {
				this.reset();
			});
		}); // cancle click		
	});//add.click
	
	
	var isExecuted = false
	//--------- 수정 버튼 ------------//
	//수정버튼 클릭
	$('#modify').click(function() {
		$('#add').attr("disabled", true);
		$('#delete').attr("disabled", true);

		// 행 하나 클릭했을 때	
		$('table tr:not(:first-child)').click(function() {

			// 하나씩만 선택 가능
			if(!isExecuted) {
				isExecuted = true;
				
				$(this).addClass('selected');
				// 수주번호 저장
				let updateCode = $(this).find('#orderCode').text().trim();
				console.log(updateCode);

				var jsonData = {
					orderCode : updateCode
				};

				var self = $(this);

				var names = [
						"order_code",
						"client_code",
						"client_actname",
						"order_date",
						"emp_id",
						"emp_name",
						"prod_code",
						"prod_name", 
						"prod.prod_unit", 
						"order_deliveryDate", 
						"order_count",
						];

				//tr안의 td 요소들 input으로 바꾸고 기존 값 띄우기
				self.find('td').each(function(idx,item) {
					if (idx > 0) {
						inputCng($(this),"text",names[idx - 1], $(this).text());
					} // 거래처 코드부터 다 수정 가능하게
				}); // self.find(~~)
				
				// 거래처 검색
				$('#client_code').click(function() {
					openWindow("client","client_code");
				}); // client_code click
				// 거래처 검색2
				$('#client_actname').click(function() {
					openWindow("client","client_code");
				}); // client_code click
				
				// 완제품 검색
				$('#prod_name').click(function() {
					openWindow("prod","prod_code");
				}); // client_code click
				
				// 완제품 검색2
				$('#prod_code').click(function() {
					openWindow("prod","prod_code");
				}); // client_code click
				
				// 담당자 검색
				$('#emp_name').click(function() {
					openWindow("emp","emp_id");
				}); // client_code click
		
				//저장버튼 -> form 제출
				$('#save').click(function() {
						
					$('#fr').attr("action","/person/updateOrder");
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
	}); // updateButton click
	
	
	//---------- 삭제 ------------- //
	$('#delete').click(function() {
		$('#add').attr("disabled", true);
		$('#modify').attr("disabled", true);

		if($(this).hasClass('true')) {
			// td 요소 중 첫번째 열 체크박스로 바꾸고 해당 행의 수주번호 저장
			$('table tr').each(function() {
				var code = $(this).find('td:nth-child(2)').text();
				
				var tbl = "<input type='checkbox' name='selected' value='";
				tbl += code;
				tbl += "'>";
				
				$(this).find('th:first').html("<input type='checkbox' id='selectAll'>");
				$(this).find('td:first').html(tbl);
			});
			
			//전체선택
			$('#selectAll').click(function() {
				var checkAll = $(this).is(":checked");

				if (checkAll) {
					$('input:checkbox').prop('checked', true);
				} else {
					$('input:checkbox').prop('checked', false);
				}
			});

			// 저장 -> 삭제
			$('#save').click(function() {

				var checked = [];

				$('input[name=selected]:checked').each(function() {
					checked.push($(this).val());
				});

				if (checked.length > 0) {

					$.ajax({
						url : "/person/deleteOrder",
						type : "post",
						data : {checked : checked},
						dataType : "text",
						success : function() {
							alert("삭제 완료");
							location.reload();
						},
						error : function() {
							alert("삭제 실패");
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
	}); //deleteButton click

	
// ========================================= 등록 ===================================================	
	
// ========================================= 검색 ===================================================
	// 수주 일자 이날부터
	$('#order_date_fromDate').datepicker({
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
			$('#order_deliveryDate_toDate').datepicker('option', 'minDate', $(this).datepicker('getDate'));
		}
	});
	
	// 이날까지
	$('#order_date_toDate').datepicker({
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
	});
	
	// 납품 예정일 이날부터
	$('#order_deliveryDate_fromDate').datepicker({
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
			$('#order_deliveryDate_toDate').datepicker('option', 'minDate', $(this).datepicker('getDate'));
		}
	});
	
	// 이날까지
	$('#order_deliveryDate_toDate').datepicker({
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
	});
	
// ========================================= 검색 ===================================================
});
</script>

<!-- page content -->
<div class="right_col" role="main">
	
	<h1 style="margin-left: 1%;">수주 관리</h1>
	
	<div style="margin-left: 1%;">
		<form method="get">
			<input type="hidden" name="input" id="input" value="${input }">
			<input type="hidden" name="client_code" id="client_code9999" >
			업체 <input type="text" name="client_actname" id="client_actname9999" onclick="serchClient('client_code9999')">
			수주 일자 <input type="text" name="order_date_fromDate" id="order_date_fromDate"> ~
					  <input type="text" name="order_date_toDate" id="order_date_toDate">
			<input type="hidden" name="prod_code" id="prod_code9999">
			품명 <input type="text" name="prod_name" id = "prod_name9999" onclick="serchProd('prod_code9999')">
			<input type="submit" value="조회">
			<br>
			<input type="hidden" name="emp_id" id="s_emp_id"> 
			담당자 <input type="text" name="emp_name" id="s_emp_name" onclick="serchEmp('emp_id9999')">
			납품 예정일 <input type="text" name="order_deliveryDate_fromDate" id="order_deliveryDate_fromDate"> ~ 
					    <input type="text" name="order_deliveryDate_toDate" id="order_deliveryDate_toDate">
		</form>
	</div>
	
	<hr>
	
	<div class="col-md-12 col-sm-12">
		<div class="x_panel">
			<form id="fr">
			
				<div class="x_title">
					<h2> 수주 목록 </h2>
					
					<span style="float: right; margin-top: 1%;"> 총 ${pm.totalCount } 건 </span>
					<div class="clearfix"></div>
				</div>
			
			<!-- 버튼 제어 -->
			<div style="margin-bottom: 1%;">
				<button id="add" class="true">추가</button>
				<button id="modify" >수정</button>
				<button id="delete" class="true">삭제</button>
				<button type="reset" id="cancle" >취소</button>
				<button type="submit" id="save">저장</button>
				<button onclick="location.href='/person/orderStatus'">새로고침</button>
			</div>
			
			<script>
			    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정
			
			    if (team === "영업팀" || team === "관리자") {
			        document.getElementById("add").disabled = false;
			        document.getElementById("modify").disabled = false;
			        document.getElementById("delete").disabled = false;
			        document.getElementById("cancle").disabled = false;
			        document.getElementById("save").disabled = false;
			        document.querySelector("[onclick^='location.href']").disabled = false;
			    } else {
			        document.getElementById("add").hidden = true;
			        document.getElementById("modify").hidden = true;
			        document.getElementById("delete").hidden = true;
			        document.getElementById("cancle").hidden = true;
			        document.getElementById("save").hidden = true;
			        document.querySelector("[onclick^='location.href']").hidden = true;
			    }
			</script>
			<!-- 버튼 제어 -->
			
			<br>
			
			<div style="overflow-x: auto;">
				<table border="1" class="table table-striped jambo_table bulk_action">
				<thead>
					<tr class="headings">
						<th></th>
						<th>수주번호</th>
						<th>수주업체코드</th>
						<th>수주업체명</th>
						<th>수주일자</th>
						<th type='hidden' style='display: none;'>담당자id</th>
						<th>담당자</th>
						<th>품번</th>
						<th>품명</th>
						<th>단위</th>
						<th>납품예정일</th>
						<th>수주량</th>
			    	</tr>
			    </thead>
					
					<c:forEach var="vo" items="${searchOrderStatusList }">
						<tr>
							<td></td>
							<td id="l_orderCode">${vo.order_code}</td>
							<td id="l_clientCode">${vo.client_code}</td>
							<td>${vo.clients.client_actname}</td>
							<td>${vo.order_date}</td>
							<td type='hidden' style='display: none;'>${vo.emp_id}</td>
							<td id="L_empName">${vo.employees.emp_name}</td>
							<td id="l_prodCode">${vo.prod_code}</td>
							<td>${vo.prod.prod_name}</td>
							<td>${vo.prod.prod_unit}</td>
							<td>${vo.order_deliveryDate}</td>
							<td>${vo.order_count}</td>
						</tr>
					</c:forEach>
				</table>
				</div>
			</form>
		</div>
	</div>
	
	<div id="pagination">
		<c:if test="${pm.prev }">
			<a href="/person/orderStatus?page=${pm.startPage - 1 }&client_code=${search.client_code}&order_date_fromDate=${search.order_date_fromDate}&order_date_toDate=${search.order_date_toDate}&prod_code=${search.prod_code}&emp_id=${search.emp_id}&order_deliveryDate_fromDate=${search.order_deliveryDate_fromDate}&order_deliveryDate_toDate=${search.order_deliveryDate_toDate}"> ⏪ </a>
		</c:if>
		
		<c:forEach var="page" begin="${pm.startPage }" end="${pm.endPage }" step="1">
			<a href="/person/orderStatus?page=${page }&client_code=${search.client_code}&order_date_fromDate=${search.order_date_fromDate}&order_date_toDate=${search.order_date_toDate}&prod_code=${search.prod_code}&emp_id=${search.emp_id}&order_deliveryDate_fromDate=${search.order_deliveryDate_fromDate}&order_deliveryDate_toDate=${search.order_deliveryDate_toDate}">${page }</a>
		</c:forEach>

		<c:if test="${pm.next }">
			<a href="/person/orderStatus?page=${pm.endPage + 1 }&client_code=${search.client_code}&order_date_fromDate=${search.order_date_fromDate}&order_date_toDate=${search.order_date_toDate}&prod_code=${search.prod_code}&emp_id=${search.emp_id}&order_deliveryDate_fromDate=${search.order_deliveryDate_fromDate}&order_deliveryDate_toDate=${search.order_deliveryDate_toDate}"> ⏩ </a>
		</c:if>
	</div>

</div>
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

