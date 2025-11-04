import Fluent
import struct Foundation.UUID

final class TodoItem: Model, @unchecked Sendable {
    static let schema = "todo_items"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String?

    @Field(key: "is_completed")
    var isCompleted: Bool

    @Parent(key: "todo_id")
    var todo: Todo

    init() { }

    init(id: UUID? = nil, name: String, description: String? = nil, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.isCompleted = isCompleted
    }

    func toDTO() -> TodoItemDTO {
        .init(
            id: self.id,
            name: self.name,
            description: self.description,
            isCompleted: self.isCompleted
        )
    }
}