//
//  AppEnvironment.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

#if os(iOS)
import UIKit

extension UIResponder {
    var appEnviroment: AppEnvironment? {
        (UIApplication.shared as? Application)?.appEnvironment
    }
}
#endif

#if os(macOS)
import AppKit

extension NSResponder {
    var appEnviroment: AppEnvironment? {
        (UIApplication.shared as? Application)?.appEnvironment
    }
}
#endif

protocol AppEnvironmentContainer {
    var appEnvironment: AppEnvironment { get }
}

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: AppEventsHandler
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        
        // Configuring Persistent Repositories
        let persistentRepositories = configuredPersistentRepositories(appState: appState)
        
        // Configuring network repositories
        let networkRepositories = configuredNetworkRepositories(session: configuredURLSession())
        
        // Configuring Services
        let services = configuredServices(pokemonSearchRepository: networkRepositories.pokemonSearchRepository,
                                          pokemonSearchPersistentRepository: persistentRepositories.pokemonSearchPersistentRepository,
                                          pokemonImageRepository: networkRepositories.pokemonImageRepository,
                                          pokemonBagListRepository: persistentRepositories.pokemonBagListRepository,
                                          pokemoneDetailRepository: persistentRepositories.pokemoneDetailRepository,
                                          appState: appState)
        
        // Configuring DIContainer
        let diContainer = DIContainer(appState: appState, services: services)
        
        // Configuring AppEventsHandler
        let systemEventsHandler = AppEventsHandlerImpl(container: diContainer)

        return AppEnvironment(container: diContainer,
                              systemEventsHandler: systemEventsHandler)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = false
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredNetworkRepositories(session: URLSession) -> DIContainer.WebRepositories {
        
        let pokemonSearchRepository = PokemonSearchRepositoryImpl(session: session,
                                                                  baseURL: "https://pokeapi.co/api")
        
        let pokemonImageRepository = PokemonImageRepositoryImpl(session: session,
                                                                baseURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon")
        
        return DIContainer.WebRepositories(pokemonSearchRepository: pokemonSearchRepository,
                                           pokemonImageRepository: pokemonImageRepository)
    }
    
    private static func configuredServices(pokemonSearchRepository: PokemonSearchRepository,
                                           pokemonSearchPersistentRepository: PokemonSearchPersistentRepository,
                                           pokemonImageRepository: PokemonImageRepository,
                                           pokemonBagListRepository: PokemonBagListRepository,
                                           pokemoneDetailRepository: PokemoneDetailRepository,
                                           appState: Store<AppState>) -> DIContainer.Services {
        
        let pokemonSerachServices = PokemonSerachServicesImpl(pokemonSearchRepository: pokemonSearchRepository,
                                                              pokemonSearchPersistentRepository: pokemonSearchPersistentRepository,
                                                              pokemonImageRepository: pokemonImageRepository,
                                                              appState: appState)
        
        let pokemonesBagListService = PokemoneBagListServiceImpl(pokemonBagListRepository: pokemonBagListRepository,
                                                                 appState: appState)
        
        let pokemoneDetailService = PokemoneDetailServiceImpl(pokemoneDetailRepository: pokemoneDetailRepository,
                                                              appState: appState)
        
        return DIContainer.Services(pokemonSerachServices: pokemonSerachServices,
                                    pokemonesBagListService: pokemonesBagListService,
                                    pokemoneDetailService: pokemoneDetailService)
    }
    
    private static func configuredPersistentRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)

        let pokemonSearchPersistentRepository = PokemonSearchPersistentRepositoryImpl(persistentStore: persistentStore)

        let pokemonBagListRepository = PokemonBagListRepositoryImpl(persistentStore: persistentStore)

        let pokemoneDetailRepository = PokemoneDetailRepositoryImpl(persistentStore: persistentStore)
        
        return DIContainer.DBRepositories(pokemonSearchPersistentRepository: pokemonSearchPersistentRepository,
                                          pokemonBagListRepository: pokemonBagListRepository,
                                          pokemoneDetailRepository: pokemoneDetailRepository)
    }
}
