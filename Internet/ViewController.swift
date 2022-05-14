//
//  ViewController.swift
//  Internet
//
//  Created by Ángel González on 13/05/22.
//

import UIKit
import Network
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webview:WKWebView!
    
    var internetStatus = false
    var internetType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monitor = NWPathMonitor()
        // un closure se ejecuta de manera asyncrona
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                self.internetStatus = false
            }
            else {
                self.internetStatus = true
                if path.usesInterfaceType(.wifi) {
                    self.internetType = "Wifi"
                }
                else if path.usesInterfaceType(.cellular) {
                    self.internetType = "Cellular"
                }
            }
        }
        // El queue global, se utiliza para ejecutar cualquier cosa en background mientras no necesitemos mayores recursos
        monitor.start(queue: DispatchQueue.global())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*if !(internetStatus) {
            let alert = UIAlertController(title: "ERRRORRRRRR!!!", message: "no hay conexión a internet!!!!!!", preferredStyle: .alert)
            let boton = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(boton)
            self.present(alert, animated:true)
        }*/
        if internetStatus {
            let alert = UIAlertController(title: "todo Ok", message: "Si hay conexión a internet de tipo " + internetType, preferredStyle: .alert)
            let boton = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(boton)
            self.present(alert, animated:true)
            // el constructor de URL puede devolver nulo si el string no es una url valida
            // if let url = URL(string: "https://www.gaceta.unam.mx/wp-content/uploads/2022/05/220512.pdf") {
            // la url puede ser tanto local, como remota
            if let url = Bundle.main.url(forResource:"geo_vertical", withExtension: "jpg") {
                // a partir del URL podemos crear un objeto URL Request
                let urlrequest = URLRequest(url: url)
                // ejecuto el request por medio del webview
                webview.load(urlrequest)
                
                // para lanzar el browser por default, necesitamos igualmente un objeto URL
                if let url = URL(string: "https://www.gaceta.unam.mx/wp-content/uploads/2022/05/220512.pdf") {
                    // UIApplication representa mi app
                    // la propiedad shared se refiere a la instancia compartida que se puede comunicar con el S.O.
                    // Es requisito validar que el dispositivo está preparado para manejar esa URL
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}

