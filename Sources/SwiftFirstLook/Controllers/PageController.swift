import Vapor

struct PageController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get(use: self.index)
    }

    @Sendable
    func index(req: Request) async throws -> View {
        let todos = try await Todo.query(on: req.db).with(\.$items).all()
        return try await req.view.render("index", ["todos": todos.map { 
            TodoDTO(
                id: $0.id,
                title: $0.title,
                items: $0.items.map { $0.toDTO() }
            )
         }])
    }
}