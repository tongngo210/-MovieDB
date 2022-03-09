import UIKit
import RxSwift
import RxCocoa
import CoreData

struct CoreDataService {
    
    static let shared = CoreDataService()
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppName.coreDataPersistentContainer)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Favorite Movie CRUD
    func addMovieToFavorite(movieId: Int, title: String, imageURLString: String,
                            releaseDate: String, rate: Double) -> Completable {
        return Completable.create { completable in
            let newObject = FavoriteMovie(context: context)
            newObject.id = Int64(movieId)
            newObject.title = title
            newObject.imageURLString = imageURLString
            newObject.releaseDate = releaseDate
            newObject.rate = rate
            save()
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func loadFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return Observable.create { obs in
            let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
            do {
                let result = try context.fetch(request)
                obs.onNext(result)
            } catch {
                obs.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func deleteFavoriteMovie(movieId: Int) -> Completable {
        return Completable.create { complete in
            let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(movieId)")
            do {
                let result = try context.fetch(request)
                for item in result {
                    context.delete(item)
                    save()
                }
                complete(.completed)
            } catch {
                complete(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func checkMovieIsFavorited(movieId: Int) -> Bool {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(movieId)")
        do {
            let result = try context.fetch(request).filter {
                movieId == Int($0.id)
            }
            if result.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
