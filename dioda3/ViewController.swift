//
//  ViewController.swift
//  dioda3
//



//  Created by Katerina Bakun on 03/05/16.
//  Copyright © 2016 Katerina Bakun. All rights reserved.
//

import UIKit
//Socket server

class ViewController: UIViewController, NSStreamDelegate {
    let addr = "192.168.1.1"
    let port = 9877

    var connectButton: UIButton!
    
    //Network variables
    var inStream : NSInputStream?
    var outStream: NSOutputStream?
    
    //Data received
    var buffer = [UInt8](count: 200, repeatedValue: 0)
    
    @IBAction func buttonRight(sender: AnyObject) {
        btnRightPressed()
    }
    @IBAction func buttonLeft(sender: AnyObject) {
        btnLeftPressed()
    }

    @IBAction func buttonOff(sender: AnyObject){
    btnOffPressed()
    }
    @IBAction func buttonSub(sender: AnyObject){
        btnSubPressed()
    }
    @IBAction func buttonOn(sender: AnyObject){
    btnOnPressed()
    }
    @IBAction func buttonAdd(sender: AnyObject){
        btnAddPressed()
    }
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var labelConnect: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    func buttonSetup (){
        connectButton = UIButton(frame: CGRectMake(20, 50, 300, 30))
        connectButton.setTitle("Connect to server", forState: UIControlState.Normal)
        connectButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        connectButton.setTitleColor(UIColor.cyanColor(), forState: UIControlState.Highlighted)
        connectButton.addTarget(self, action: "btnConnectPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(connectButton)
    //buttonOn.addTarget(self, action: "btnOnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    //buttonOff.addTarget(self, action: "btnOffPressed", forControlEvents: UIControlEvents.TouchUpInside)
    //buttonAdd.addTarget(self, action: "btnAddPressed", forControlEvents: UIControlEvents.TouchUpInside)
    //buttonSub.addTarget(self, action: "btnSubPressed", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func btnConnectPressed(sender: UIButton) {
        NetworkEnable()
        
        connectButton.alpha = 0.3
        connectButton.enabled = false
        connectButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //repeatSignal()
    }
    func btnLeftPressed(){
        let data: NSData = "LEFT".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    func btnRightPressed(){
        let data: NSData = "RIGHT".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }

    func btnOnPressed( ){
        let data: NSData = "ON".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    func btnOffPressed (){
        let data: NSData = "OFF".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    func btnAddPressed(){
        let data: NSData = "ADD".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    func btnSubPressed(){
        let data: NSData = "SUB".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    func repeatSignal(){
        let data : NSData = "REPEAT".dataUsingEncoding(NSUTF8StringEncoding)!

        repeat{
            
            
            delay(3){
                self.outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            }
        
        }
            while labelConnect.text == "Connected to server"
    }


    func NetworkEnable() {
    
    print("NetworkEnable")
    NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inStream, outputStream: &outStream)
    
    inStream?.delegate = self
    outStream?.delegate = self
    
    inStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    outStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    
    inStream?.open()
    outStream?.open()
    
    buffer = [UInt8](count: 200, repeatedValue: 0)
    }
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.EndEncountered:
            print("EndEncountered")
            labelConnect.text = "Connection stopped by server"
            inStream?.close()
            inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            connectButton.alpha = 1
            connectButton.enabled = true
        case NSStreamEvent.ErrorOccurred:
            print("ErrorOccurred")
            
            inStream?.close()
            inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream?.close()
            outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            labelConnect.text = "Failed to connect to server"
           connectButton.alpha = 1
            connectButton.enabled = true
            textField.text = ""
        case NSStreamEvent.HasBytesAvailable:
            print("HasBytesAvailable")
            
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                textField.text = bufferStr! as String
                print(bufferStr!)
            }
            
        case NSStreamEvent.HasSpaceAvailable:
            print("HasSpaceAvailable")
        case NSStreamEvent.None:
            print("None")
        case NSStreamEvent.OpenCompleted:
            print("OpenCompleted")
            labelConnect.text = "Connected to server"
            
        default:
            print("Unknown")
        }
    }

    
        }
    




