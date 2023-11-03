<%@page import="com.project.*"%>
<%@page import="com.project.model.common.Paging"%>
<%@page import="com.project.model.vo.BookVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../user/category.jsp" %> 
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>
<!-- 검색창에서 검색을 했을 때 나오는 결과(책리스트) -->

<% 


Integer datasize = 0;
System.out.println("search : " + request.getAttribute("search"));
System.out.println("searchOption : " + request.getAttribute("searchOption"));
	if (request.getAttribute("list") != null ){
		datasize = (Integer) request.getAttribute("size");
		System.out.println("Received parameter: " + datasize);
 	 }
	
 %>
 
<%
	//0. 페이징 처리를 위한 객체(Paging) 생성
	 try {
	Paging p = new Paging();

	//1. 전체 게시물 수량 구하기
	p.setTotalRecord(datasize);
	p.setTotalPage();
	System.out.println("> 전체 게시글 수 : " + p.getTotalRecord());
	System.out.println("> 전체 페이지 수 : " + p.getTotalPage());
	
	//2. 현재 페이지 구하기
	String cPage = request.getParameter("cPage");
	if (cPage != null) {
		p.setNowPage(Integer.parseInt(cPage));
	}
	System.out.println("> cPage : " + cPage);
	System.out.println("> paging nowPage : " + p.getNowPage());
	
	//3. 현재 페이지에 표시할 게시글 시작번호(begin), 끝번호 구하지
	int fixedNumPerPage = 3; // 고정된 페이지당 게시글 수

	p.setEnd(p.getNowPage() * fixedNumPerPage);
	p.setBegin(p.getEnd() - fixedNumPerPage + 1);
	
	//3-1. (선택적) 끝 번호가 데이터 건수보다 많아지면 데이터 건수와 동일하게 설정
	if (p.getEnd() > p.getTotalRecord()) {
		p.setEnd(p.getTotalRecord());
	}
	
	System.out.println(">> 시작번호(begin) : " + p.getBegin());
	System.out.println(">> 끝번호(end) : " + p.getEnd());
	
	//------ 블록(block) 게산하기 -----------------
	//4. 블록 시작페이지, 끝페이지 구하기
	//4-1. 시작페이지 구하기
	int beginPage = (p.getNowPage() - 1) / p.getPagePerBlock() * p.getPagePerBlock() + 1;
	p.setBeginPage(beginPage);
	p.setEndPage(beginPage + p.getPagePerBlock() -1);
	
	//4-2. 끝페이지(endPage)가 전체 페이지 수(totalPage) 보다 크면
	// 끝페이지를 전체 페이지 수로 변경처리(설정)
	if (p.getEndPage() > p.getTotalPage()) {
		p.setEndPage(p.getTotalPage());
	}
	
	System.out.println(">> 시작페이지(beginPage) : " + p.getBeginPage());
	System.out.println(">> 끝페이지(endPage) : " + p.getEndPage());
	System.out.println(">> p.getTotalPage() : " + p.getTotalPage());
	
	System.out.println("p : " + p);
%>
<%

	//검색 결과를 데이터베이스 또는 다른 소스에서 가져옴
	List<BookVO> searchData = null;
	List<BookVO> list = null; 
	
		searchData = (List<BookVO>)request.getAttribute("list");
		System.out.println("list222searchData : " + searchData);
		int begin = p.getBegin() - 1;
		list = searchData.subList(begin, p.getEnd());
		System.out.println("리스트 : " + list);

	
	
	
	// 현재 페이지에 해당하는 데이터만 추출
	//List<YourDataClass> currentPageData = searchData.subList(begin, end);
	//================================
	//현재 페이지 기준으로 DB데이터(게시글) 가져오기
	//시작번호(begin), 끝번호(end) 사용해서
	//List<BbsVO> list = adminBookDAO.getPageList(p.getBegin(), p.getEnd());
	//System.out.println(">> 현재 페이지 글목록(list) : " + list);
	 
	
	//--------------------------
	//JSTL, EL 사용을 위해 scope에 데이터 등록(page 영역)
	pageContext.setAttribute("list", list);
	pageContext.setAttribute("pvo", p);
	
	//(개인적실습) 현재 페이지번호 사용 블록번호 구하고, 블록번호로 시작/끝 페이지 구하기
	System.out.println("p : " + p);	} catch (Exception e) {
        // 예외 처리: 예외 메시지를 출력하거나 다른 처리를 수행할 수 있음
        e.printStackTrace();
        // 여기에 예외 처리 로직을 추가하십시오.
    }
%> 
<!DOCTYPE html>
  <link href="../appdata/css/main.css" rel="stylesheet">
<script>
    function goBack() {
        location.href = "userSearchAll.jsp"; // userSearchAll.jsp 페이지로 이동
    }
</script>

<!-- 관리자가 책을 삭제, 수정, 등록하기 위해 책리스트를 뽑아오기 -->
<script type="text/javascript">
function book_insert() {
	location.href = "bookInsert.jsp";
}
function book_update() {
    var selectedBook = document.querySelector('input[name="selectedBook"]:checked');
    
    if (!selectedBook) {
        alert("수정할 책을 선택하세요.");
    } else {
        // 선택된 책의 bookId 값을 사용하여 수정 페이지로 이동합니다.
    	window.location.href = "bookListOne?bookId=" + selectedBook.value;
    }
}

function book_delete() {
    var selectedBook = document.querySelector('input[name="selectedBook"]:checked');
    
    if (!selectedBook) {
        alert("삭제할 책을 선택하세요.");
    } else {
        // 선택된 책의 bookId 값을 사용하여 삭제 페이지로 이동합니다.
        var confirmation = confirm("선택한 책을 삭제하시겠습니까?");
        
        if (confirmation) {
            // "예"를 선택한 경우, 선택된 책의 bookId 값을 사용하여 삭제 페이지로 이동합니다.
            window.location.href = "bookDelete?bookId=" + selectedBook.value;
        }
    }
}


function submitForm() {
    document.forms[0].submit(); // 폼 제출
}

</script>
<html>
<head>
    <meta charset="UTF-8">
<style>
	#bbs table {
		width: 580px;
		margin-left: 10px;
		border-collapse: collapse;
		font-size: 14px;
	}
	#bbs table caption {
		font-size: 20px;
		font-weight: bold;
		margin-bottom: 10px;
	}
	#bbs th, #bbs td {
		border: 1px solid black;
		padding: 4px 10px;
		text-align: center;
	}
	#bbs .align-left { text-align: left; }
	
	.title { background-color: lightsteelblue; }
	.no { width: 10%; }
	.writer { width: 15%; }
	.regdate { width: 20%; }
	.hit { width: 15%; }
	
	/*** 페이지 표시 영역 스타일(시작) ***/
	.paging { list-style: none; }
	.paging li {
		float: left;
		margin-right: 8px;
	}
	.paging li a {
		text-decoration: none;
		display: block;
		padding: 3px 7px;
		border: 1px solid #00b3dc;
		font-weight: bold;
		color: black;
	}
	.paging .disable {
		border: 1px solid silver;
		padding: 3px 7px;
		color: silver;
	}
	.paging .now {
		border: 1px solid #ff4aa5;
		padding: 3px 7px;
		background-color: #ff4aa5;
	}
	/*** 페이지 표시 영역 스타일(끝) ***/
</style>
    <title>통합검색결과</title>
</head>

<body>
<div class="inner">
    <h2>통합검색결과</h2>
   
     <c:choose>
        <c:when test="${empty list}">
            <p>"${search }"에 대한 검색 결과가 없습니다.</p>
            <button onclick="window.location.href='bookList.jsp'">이전페이지로 돌아가기</button>
        </c:when>
        <c:otherwise> 
            <table border="1">
                <tr>
                    <th>카테고리</th>
                    <th>책이름</th>
                    <th>가격</th>
                    <th>출판사</th>
                    <th>작가</th>
                    <th>책설명</th>
                    <th>책이미지</th>
                </tr>
               <c:forEach var="vo" items="${list}">
	<tr>
		<td><input type="radio" name="selectedBook" value="${vo.bookId}" /></td>
		<td>${vo.category}</td>
		<td>${vo.bookName}</td>
		<td>${vo.price}</td>
		<td>${vo.publisher}</td>
		<td>${vo.author}</td>
		<td>${vo.details}</td>
		<td> <img src="<c:url value='/upload/${vo.bookImage}' />" alt="Image" style="width: 100px; height: 100px;"></td>
	</tr>
</c:forEach>
</table>
<div class="button-container">
	<button onclick="book_update()">책정보수정</button>
	<button onclick="book_delete()">책삭제</button>
</div>
                <tfoot>
			<tr>
				<td colspan="4">
					<ol class="paging">
					<%--[이전페이지이동]에 대한 사용여부 처리 --%>
									<c:if test="${pvo.beginPage == 1 }">
						<li class="disable"><<</li>
					</c:if>
					<c:if test="${pvo.beginPage != 1 }">
						<li>
							<a href="searchList?searchOption=${searchOption }&search=${search}&cPage=${pvo.beginPage - 1 }"><<</a>
						</li>
					</c:if>	
					
					<%--[이전으로]에 대한 사용여부 처리 --%>
					<c:if test="${cPage == 1 || cPage == null}">
						<li class="disable"><</li>
					</c:if>
					<c:if test="${cPage != 1 && cPage != null}">
						<li>
							<a href="searchList?searchOption=${searchOption }&search=${search}&cPage=${cPage - 1 }"><</a>
						</li>
					</c:if>	
					
					<%--블록내에 표시할 페이지 태그 작성(시작페이지~끝페이지) --%>
					<c:forEach var="pageNo" begin="${pvo.beginPage }" end="${pvo.endPage }">
					<c:if test="${pageNo == pvo.nowPage }">
						<li class="now">${pageNo}</li>
					</c:if>	
					<c:if test="${pageNo != pvo.nowPage }">
						<li>
							<a href="searchList?searchOption=${searchOption }&search=${search}&cPage=${pageNo }&size=${size}">${pageNo }</a>
						</li>
					</c:if>		
						
					</c:forEach>
					
					<%--[다음으로]에 대한 사용여부 처리 --%>
					<c:if test="${cPage == pvo.totalPage || pvo.totalRecord < 4}">
						<li class="disable">></li>
					</c:if>

					<c:if test="${cPage != pvo.totalPage && pvo.totalRecord > 3}">
						<li>
							<a href="searchList?searchOption=${searchOption }&search=${search}&cPage=${cPage + 1 }&size=${size}">></a>
						</li>
					</c:if>	
					
					<%--[다음페이지이동]에 대한 사용여부 처리 --%>
					<c:if test="${pvo.endPage >= pvo.totalPage }">
						<li class="disable">>></li>
					</c:if>
					<c:if test="${pvo.endPage < pvo.totalPage }">
						<li>
							<a href="searchList?searchOption=${searchOption }&search=${search}&cPage=${pvo.endPage + 1 }&size=${size}">>></a>
						</li>
					</c:if>		 
					</ol>
				
				</td>

			</tr>
		</tfoot>
            </table>
            <button onclick="window.location.href='bookList.jsp'">이전페이지로 돌아가기</button>
        </c:otherwise>
    </c:choose> 
    </div>
</body>
</html>