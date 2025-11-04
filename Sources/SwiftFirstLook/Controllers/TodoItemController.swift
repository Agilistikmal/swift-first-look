import Fluent
import Vapor

struct TodoItemController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todoItems = routes.grouped("todos", ":todoID", "items")

        todoItems.get(use: self.index)
        todoItems.post(use: self.create)
        todoItems.group(":todoItemID") { todoItem in
            todoItem.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [TodoItemDTO] {
        let todoItems = try await TodoItem.query(on: req.db).all()
        if todoItems.isEmpty {
            return []
        }
        return todoItems.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> [TodoItemDTO] {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing Todo ID in route.")
        }

        let todoItems = try req.content
            .decode([TodoItemDTO].self)
            .map { $0.toModel() }

        todoItems.forEach { $0.$todo.id = todoID }
        
        try await todoItems.create(on: req.db)
        return todoItems.map { $0.toDTO() }
    }

    @Sendable
    func updateIsCompleted(req: Request) async throws -> TodoItemDTO {
        guard let todoItem = try await TodoItem.find(req.parameters.get("todoItemID"), on: req.db) else {
            throw Abort(.notFound)
        }
        todoItem.isCompleted = !todoItem.isCompleted

        try await todoItem.save(on: req.db)
        return todoItem.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todoItem = try await TodoItem.find(req.parameters.get("todoItemID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await todoItem.delete(on: req.db)
        return .noContent
    }
}