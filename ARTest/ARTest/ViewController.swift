import UIKit
import ARKit
import SceneKit
import AVFoundation
import AssetsLibrary

var expressionarray = [[Float]]()
var timer: Timer!
var startTime = Date()
var time:[Float] = [0]
var preview = true
var blendshape = true
var RecordingName = "Recording"
var count = 0

class ViewController: UIViewController, ARSessionDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet var label: UILabel!
    @IBOutlet var timerMinute: UILabel!
    @IBOutlet var timerSecond: UILabel!
    @IBOutlet var timerMSec: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    
    var session: ARSession {
        return sceneView.session
    }
    
    let contentUpdater = VirtualContentUpdater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = contentUpdater
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true //シーンの照明を更新するかどうか

        
        contentUpdater.virtualFaceNode = createFaceNode()
        //Setting up Recording Session
        
    AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission
            {
                print("ACCEPTED")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true //デバイスの自動光調節をOFF
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //session.pause() //セッション停止
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent(RecordingName + String(count) + ".m4a")
        return url
    }
    
    @IBAction func StartButton(_ sender: UIButton) {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        
        startSession()
        preview = false
        blendshape = true
        expressionarray = [[Float]]()
        
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        startTime = Date()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        
        isRecording = true
        label.textColor = UIColor.red
        label.text = "Recording!"
        
    }

    @IBAction func StopButton(_ sender: UIButton) {
        preview = true
        createFile(fileName : RecordingName + String(count), fileArrData : expressionarray)

        if timer != nil{
            timer.invalidate()
            
            timerMinute.text = "00"
            timerSecond.text = "00"
            timerMSec.text = "00"
        }
        
        audioRecorder.stop()
        isRecording = false
        label.textColor = UIColor.white
        label.text = "Ready"
        count = count + 1
        expressionarray.removeAll()
    }
    
    //マスクを生成
    public func createFaceNode() -> VirtualFaceNode? {
        guard
            let device = sceneView.device,
            let geometry = ARSCNFaceGeometry(device : device) else {
                return nil
        }
        
        return Mask(geometry: geometry)
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
        
        // %02d： ２桁表示、0で埋める
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
        
        time[0] = Float(currentTime)
        
        timerMinute.text = sMinute
        timerSecond.text = sSecond
        timerMSec.text = sMsec
        
    }
    
    //セッション開始
    func startSession() {
        print("STARTING A NEW SESSION")
        guard ARFaceTrackingConfiguration.isSupported else { return } //ARFaceTrackingをサポートしているか
        let configuration = ARFaceTrackingConfiguration() //顔の追跡を実行するための設定
        configuration.isLightEstimationEnabled = true //オブジェクトにシーンのライティングを提供するか
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //MARK: - ARSessionDelegat
    //エラーの時
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        print("SESSION ERROR")
    }
    //中断した時
    func sessionWasInterrupted(_ session: ARSession) {
        timer.invalidate()
        session.pause() //セッション停止
        print("SESSION INTERRUPTED")
    }
    //中断再開した時
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.startSession() //セッション再開
        }
    }

}
