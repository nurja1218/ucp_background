import Foundation
import CoreData
import AppKit

//@available(OSX 11.0, *)
@available(OSX 11.0, *)
class CoreDataManager: NSObject {
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
   
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Users"
    
    func getUsers(ascending: Bool = false) -> [Users] {
        var models: [Users] = [Users]()
        
        if let context = context {
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
                = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            
            do {
                if let fetchResult: [Users] = try context.fetch(fetchRequest) as? [Users] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    func getUser(query:String) -> Users    {
        //let query = "Rob"
        var model: Users = Users()
        
    //    let request: NSFetchRequest<Users> = Users.fetchRequest()
    
        if let context = context {
            
            let fetchRequest: NSFetchRequest<NSManagedObject>
                              = NSFetchRequest<NSManagedObject>(entityName: "Users")
                      
                 
                 // The == syntax may also be used to search for an exact match
                 fetchRequest.predicate = NSPredicate(format: "userid == %@", query)
                  
                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
                 
                     //let name = fetchResult.name
                     
                     //let id = fetchResult.userid
                     if(fetchResult.count > 0)
                     {
                         print("find")
                        
                        for listEntity in fetchResult {
                            let user = listEntity as! Users
                            print(user as Any)
                            let userid = user.userid
                            let password = user.password
                            
                           
                            model = user
                            return model
                          
                        }
                     }
                     
                     
                           // model = fetchResult
                 }
            
        }
     
      
        return model
        
    }
    
    func saveUser(name:String, id: String, password: String,
                  country: String, answer:String, type:String, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context
        {
            let fetchRequest: NSFetchRequest<NSManagedObject>
                                           = NSFetchRequest<NSManagedObject>(entityName: "Users")
                                   
               
            fetchRequest.predicate = NSPredicate(format: "userid == %@", id)
                                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
            
                if(fetchResult.count == 0)
                {
                    
                    let entity: NSEntityDescription
                        = NSEntityDescription.entity(forEntityName: modelName, in: context)!
                        
                    let user: Users = (NSManagedObject(entity: entity, insertInto: context) as? Users)!
                    
                    user.name = name
                    user.userid = id
                    user.country = country
                    user.password = password
                    user.type = type
                    user.answer = answer
                    
                    contextSave { success in
                        onSuccess(success)
                    }
                }
                else
                {
                    
                    
                    fetchResult[0].setValue(name, forKey: "name")
                    fetchResult[0].setValue(id, forKey: "userid")
                    fetchResult[0].setValue(country, forKey: "country")
                                
                    fetchResult[0].setValue(password, forKey: "password")
                              
                    fetchResult[0].setValue(type, forKey: "type")
                     
                    fetchResult[0].setValue(answer, forKey: "answer")
                    contextSave { success in
                        onSuccess(success)
                    }

                }
            }
        }
        
        
    }
    func saveAppList(name:String, type: String, group: String,
                  process: String, etc:String, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context
        {
            let fetchRequest: NSFetchRequest<NSManagedObject>
                                           = NSFetchRequest<NSManagedObject>(entityName: "AppList")
                                   
               
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
            
                if(fetchResult.count == 0)
                {
                    
                    let entity: NSEntityDescription
                        = NSEntityDescription.entity(forEntityName: "AppList", in: context)!
                        
                    let user: AppList = (NSManagedObject(entity: entity, insertInto: context) as? AppList)!
                    
                    user.name = name
                    user.type = type
                    user.group = group
                    user.etc = etc
                    user.process = process
                    
                    contextSave { success in
                        onSuccess(success)
                    }
                }
                else
                {
                    
                    
                    fetchResult[0].setValue(name, forKey: "name")
                    fetchResult[0].setValue(type, forKey: "type")
                    fetchResult[0].setValue(group, forKey: "group")
                                
                    fetchResult[0].setValue(etc, forKey: "etc")
                              
                    fetchResult[0].setValue(process, forKey: "process")
                     
                  
                    contextSave { success in
                        onSuccess(success)
                    }

                }
            }
        }
        
        
    }
    func saveCommand(name:String, type: String, group: String,
                  gesture: String, shortcut:String, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context
        {
            let fetchRequest: NSFetchRequest<NSManagedObject>
                                           = NSFetchRequest<NSManagedObject>(entityName: "Command")
                                   
               
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
            
                if(fetchResult.count == 0)
                {
                    
                    let entity: NSEntityDescription
                        = NSEntityDescription.entity(forEntityName: "Command", in: context)!
                        
                    let user: Command = (NSManagedObject(entity: entity, insertInto: context) as? Command)!
                    
                    user.name = name
                    user.type = type
                    user.group = group
                    user.gesture = gesture
                    user.shortcut = shortcut
                    
                    contextSave { success in
                        onSuccess(success)
                    }
                }
                else
                {
                    
                    
                    fetchResult[0].setValue(name, forKey: "name")
                    fetchResult[0].setValue(type, forKey: "type")
                    fetchResult[0].setValue(group, forKey: "group")
                                
                    fetchResult[0].setValue(gesture, forKey: "gesture")
                              
                    fetchResult[0].setValue(shortcut, forKey: "shortcut")
                     
                  
                    contextSave { success in
                        onSuccess(success)
                    }

                }
            }
        }
        
        
    }
    func getCommand(query:String) -> Command    {
        //let query = "Rob"
        
        var model: Command = Command()
        
    //    let request: NSFetchRequest<Users> = Users.fetchRequest()
    
        if let context = context {
            
            let fetchRequest: NSFetchRequest<NSManagedObject>
                              = NSFetchRequest<NSManagedObject>(entityName: "Command")
                      
                 
                 // The == syntax may also be used to search for an exact match
                 fetchRequest.predicate = NSPredicate(format: "name == %@", query)
                  
                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
                 
                     //let name = fetchResult.name
                     
                     //let id = fetchResult.userid
                     if(fetchResult.count > 0)
                     {
                         print("find")
                        
                        for listEntity in fetchResult {
                            let app = listEntity as! Command
                            
                           
                            model = app
                            return model
                          
                        }
                     }
                     
                     
                           // model = fetchResult
                 }
            
        }
     
      
        return model
        
    }
    func getAppList(query:String) -> AppList    {
        //let query = "Rob"
        
        var model: AppList = AppList()
        
    //    let request: NSFetchRequest<Users> = Users.fetchRequest()
    
        if let context = context {
            
            let fetchRequest: NSFetchRequest<NSManagedObject>
                              = NSFetchRequest<NSManagedObject>(entityName: "AppList")
                      
                 
                 // The == syntax may also be used to search for an exact match
                 fetchRequest.predicate = NSPredicate(format: "name == %@", query)
                  
                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
                 
                     //let name = fetchResult.name
                     
                     //let id = fetchResult.userid
                     if(fetchResult.count > 0)
                     {
                         print("find")
                        
                        for listEntity in fetchResult {
                            let app = listEntity as! AppList
                            
                           
                            model = app
                            return model
                          
                        }
                     }
                     
                     
                           // model = fetchResult
                 }
            
        }
     
      
        return model
        
    }
    func saveUserList(type:String, id: Int, answer: String,
                  onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context {
            
            
        
            let fetchRequest: NSFetchRequest<NSManagedObject>
                                    = NSFetchRequest<NSManagedObject>(entityName: "UserList")
                            
                       
                       // The == syntax may also be used to search for an exact match
        
        
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                        
                
            if let fetchResult = try? context.fetch(fetchRequest)  {
                      
                if(fetchResult.count == 0)
                {
                    
                    let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "UserList" , in: context)!
                              
                              
                    let userList:UserList = (NSManagedObject(entity: entity, insertInto: context) as! UserList)
                    
                    userList.id = Int64(id)
                    
                    userList.type = type
                    
                    userList.answer = answer
                    
                    contextSave { success in
                    
                        onSuccess(success)
                        
                    }
                    
                    
                }
                else
                {
                    
                    fetchResult[0].setValue(Int64(id), forKey: "id")
                    
                    fetchResult[0].setValue(type, forKey: "type")
                    
                    fetchResult[0].setValue(answer, forKey: "answer")
                    contextSave { success in
                                       
                        onSuccess(success)
                                           
                                       
                    }
                    
                }
                  
            }
         
      
          
        }
    }
    func getUserType(query:String) -> String    {
        //let query = "Rob"
        var model: Users = Users()
        
    //    let request: NSFetchRequest<Users> = Users.fetchRequest()
    
        if let context = context {
            
            let fetchRequest: NSFetchRequest<NSManagedObject>
                              = NSFetchRequest<NSManagedObject>(entityName: "UserList")
                      
                 
                 // The == syntax may also be used to search for an exact match
          
            fetchRequest.predicate = NSPredicate(format: "answer == %@", query)
                  
                  
            if let fetchResult = try? context.fetch(fetchRequest)  {
                 
                     //let name = fetchResult.name
                     
                     //let id = fetchResult.userid
                     if(fetchResult.count > 0)
                     {
                         print("find")
                        
                        for listEntity in fetchResult {
                            let user = listEntity as! UserList
                         //   print(user as Any)
                            let type = user.type
                        //    context.delete(listEntity)
                          //  let password = user.password
                            
                           
                            //model = user
                            return type!
                          
                        }
                      //  try? context.save()

                     }
                     
                     
                           // model = fetchResult
                 }
            
        }
           return ""
            
       
    }
        
    
    func deleteUser(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        
        do {
            if let results: [Users] = try context?.fetch(fetchRequest) as? [Users] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}

@available(OSX 11.0, *)
extension CoreDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        
        
        
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
    fileprivate func contextUpdate(onSuccess: ((Bool) -> Void)) {
           do {
                 
               try context?.save()
               onSuccess(true)
           } catch let error as NSError {
               print("Could not save🥶: \(error), \(error.userInfo)")
               onSuccess(false)
           }
       }
}
