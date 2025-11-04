import Fluent

struct CreateTodoItem: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("todo_items")
            .id()
            .field("name", .string, .required)
            .field("description", .string)
            .field("is_completed", .bool, .required)
            .field("todo_id", .uuid, .required, .references("todos", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("todo_items").delete()
    }
}