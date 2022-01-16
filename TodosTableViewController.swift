//
//  TodosTableViewController.swift
//  Todos
//
//  Created by SH.Jung on 2021/07/27.
//

import UIKit
import UserNotifications

class TodosTableViewController: UITableViewController {

	// MARK: - Properties
	// MARK: Privates
	/// todo 목록
	private var todos: [Todo] = Todo.all
	
	/// 셀에 표시할 날짜를 포멧하기 위한 Date Formatter
	private let dateFormatter: DateFormatter = {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateStyle = DateFormatter.Style.medium
		formatter.timeStyle = DateFormatter.Style.short
		return formatter
	}()
	
	// MARK: - Methods
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// UIViewController에서제공하는 기본 수정버튼
		self.navigationItem.leftBarButtonItem = self.editButtonItem
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// 화면이 보여질 때마다 todo 목록을 새로고침
		self.todos = Todo.all
		self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.automatic)
	}
	
	// MARK: - Table view data source
	/// 테이블뷰의 섹션 수 (기본값 1)
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return self.todos.count
	}
	
	/// 인덱스에 해당하는 cell 반환
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// 스토리보드에 구현해 둔 셀을 재사용 큐에서 꺼내옴
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
		
		guard indexPath.row < self.todos.count else { return cell }
		
		let todo: Todo = self.todos[indexPath.row]
		
		// 셀에 내용 설정
		cell.textLabel?.text = todo.title
		cell.detailTextLabel?.text = self.dateFormatter.string(from: todo.due)
		
		return cell
	}
	
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let todoViewController: TodoViewController = segue.destination as? TodoViewController else {
			return
		}
		
		guard let cell: UITableViewCell = sender as? UITableViewCell else { return }
		guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return }
		
		guard index.row < todos.count else { return }
		let todo: Todo = todos[index.row]
		todoViewController.todo = todo
	}
}

/// User Notifications의 Deledate 메서드 구현
extension TodosTableViewController: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		let idToShow: String = response.notification.request.identifier
		guard let todoToShow: Todo = self.todos.filter({ (todo: Todo) -> Bool in
			return todo.id == idToShow
		}).first else {
			return
		}
		
		guard let todoViewController: TodoViewController = self.storyboard?.instantiateViewController(withIdentifier: TodoViewController.storyboardID) as? TodoViewController else { return }
		
		todoViewController.todo = todoToShow
		
		self.navigationController?.pushViewController(todoViewController, animated: true)
		UIApplication.shared.applicationIconBadgeNumber = 0
		
		completionHandler()
	}
}



















