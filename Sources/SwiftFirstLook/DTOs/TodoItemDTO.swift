import Vapor

struct TodoItemDTO: Content {
    var id: UUID?
    var name: String
    var description: String?
    var isCompleted: Bool?

    func toModel() -> TodoItem {
        let model = TodoItem()
        model.id = self.id
        model.name = self.name
        model.description = self.description
        model.isCompleted = self.isCompleted ?? false
        return model
    }
}