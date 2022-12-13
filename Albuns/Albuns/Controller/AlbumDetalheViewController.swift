//
//  AlbumDetalheViewController.swift
//  Albuns
//
//  Created by Professor on 23/10/21.
//

import UIKit

class AlbumDetalheViewController: UITableViewController {
    private var album: Album?
    private var modelDelegate: AlbumModelChangedDelegate?
    private var imagePicker = UIImagePickerController()
    private var atualizaFoto = false
    
    @IBOutlet weak var aCapa: UIImageView!
    @IBOutlet weak var oAlbum: UITextField!
    @IBOutlet weak var aBanda: UITextField!
    @IBOutlet weak var oEstilo: UITextField!
    @IBOutlet weak var oAno: UITextField!
    @IBOutlet weak var oVideo: UITextField!
    @IBOutlet weak var abrirVideo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registraKeyboard()
        configuraTouch()
        confiuraCampos()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let album = album {
            // Carregar a imagem da capa do album
            if let capaData = album.capa, !atualizaFoto {
                aCapa.image = UIImage(data: capaData)
            }
            oAlbum.text = album.nome
            aBanda.text = album.banda
            oEstilo.text = album.estilo
            oAno.text = album.ano.description
            if let url = album.url {
                oVideo.text = url
                abrirVideo.isEnabled = url.count > 0        // <<==
            }
        }
    }
    
    func configure(with album: Album?, delegate: AlbumModelChangedDelegate) {
        self.album = album
        self.modelDelegate = delegate
    }
    
    @IBAction func abrirVideo(_ sender: Any) {        // <<==
        if let oEndereco = URL(string: oVideo.text!) {
            UIApplication.shared.open(oEndereco)
        }
    }
    
    @IBAction func salvar(_ sender: Any) {
        do {
            let dataBase = DataBaseController.sharedInstance
            if let velhoAlbum = album {
                velhoAlbum.nome = oAlbum.text!
                velhoAlbum.banda = aBanda.text!
                velhoAlbum.ano = oAno.text!.numberValue
                velhoAlbum.estilo = oEstilo.text!
                velhoAlbum.capa = aCapa.image?.pngData()
                velhoAlbum.url = oVideo.text!
            } else {
                let novoAlbum = dataBase.novoAlbum()
                novoAlbum.nome = oAlbum.text!
                novoAlbum.banda = aBanda.text!
                novoAlbum.ano = oAno.text!.numberValue
                novoAlbum.estilo = oEstilo.text!
                novoAlbum.capa = aCapa.image?.pngData()
                novoAlbum.url = oVideo.text!
            }
            try dataBase.salvar()
            modelDelegate?.albumModelChanged()
            _ = navigationController?.popToRootViewController(animated: true)
        } catch {
            alert("Falha ao gravar", message: "O Álbum não pode ser gravado")
        }
    }
}

extension AlbumDetalheViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func configuraTouch() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(fromGallery))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        aCapa.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(fromCamera))
        doubleTap.numberOfTapsRequired = 1
        doubleTap.numberOfTouchesRequired = 2
        aCapa.addGestureRecognizer(doubleTap)
    }
    
    @objc func fromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func fromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.cameraCaptureMode = .photo
            imagePicker.showsCameraControls = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            atualizaFoto = true
            self.aCapa.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AlbumDetalheViewController: UITextFieldDelegate {
    func confiuraCampos() {
        oAlbum.delegate = self
        aBanda.delegate = self
        oEstilo.delegate = self
        oAno.delegate = self
        oVideo.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {        // <<==
        if textField == oVideo {
            abrirVideo.isEnabled = oVideo.text!.count > 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oAlbum:
            aBanda.becomeFirstResponder()
        case aBanda:
            oEstilo.becomeFirstResponder()
        case oEstilo:
            oAno.becomeFirstResponder()
        case oAno:
            oVideo.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
