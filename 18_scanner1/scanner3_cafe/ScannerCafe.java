package com.mystudy.scanner3_cafe;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.jar.Attributes.Name;

public class ScannerCafe {

	int menu;
	int num;
	int money;
	int incoin;
	final int AME = 3000; //final을 쓰면 값을 바꾸지 못한다. //public을 쓰면 어디서는 사용가능하다
	final int CAFE = 3500;
	final int MOCA = 4000;
	final int JUICE = 5000;
	
	ArrayList<Integer> ar = new ArrayList<>();
	
	
	public void start() {
		Scanner scan = new Scanner(System.in);
		
		while (true) {
			//입력
			input(scan);
			
			System.out.println("-----메뉴를 추가로 주문하시겠습니까?(예or아니요)-------");
			String a1 = scan.next();
			if (a1.equals("아니요")) {
				System.out.println("주문이 완료되었습니다.");
				//System.out.println("오늘의 매출 : " + incoin);
				break;
			} else if (a1.equals("예")) {
				//System.out.println("오늘의 매출 : " + incoin);
				continue;
			}

		}
	}
	
	public void input(Scanner scan) {
		
		System.out.println("1.아메리카노 2.카페라떼 3.카페모카 4.과일주스");
		System.out.print("> 메뉴를 선택하시오(1~4) : ");
		int menu = scan.nextInt();

		System.out.print("> 주문수량 : ");
		int num = scan.nextInt();

		System.out.print("> 입금액 : ");
		int money = scan.nextInt();

		System.out.println("============");
		System.out.println("입금액 : " + money);
		
		ar.add(AME);
		ar.add(CAFE);
		ar.add(JUICE);
		ar.add(MOCA);
		
		for (int i = 0; i <= ar.size(); i++) {
			int a = ar.get(i) * num;
			if (menu == i) {
				System.out.println("판매액 : " + a);
				System.out.println("잔돈 : " + (money - a));
				}
		}
		/*
		 **if문 대신 스위치문도 사용 가능하다.
		 switch (menu) {
		 case 1 : totMoney = AM * count; break;
		 case 2 : totMoney = CAFE * count; break;
		 case 3 : totMoney = MOCA * count; break;
		 case 4 : totMoney = JUICE * count; break;
		 */	
	
	}

}