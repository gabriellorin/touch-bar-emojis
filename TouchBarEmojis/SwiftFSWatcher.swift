//
//  SwiftFSWatcher.swift
//  SwiftFSWatcher
//
//  Created by Gurinder Hans on 4/9/16.
//  Copyright © 2016 Gurinder Hans. All rights reserved.
//

@objc open class SwiftFSWatcher : NSObject {

    var stream: FSEventStreamRef?

    var onChangeCallback: (([FileEvent]) -> Void)?

    open var watchingPaths: [String]? {
        didSet {
            guard stream != nil else {
                return
            }

            pause()
            stream = nil
            watch(onChangeCallback)
        }
    }


    // MARK: - Init methods

    public override init() {
        // Default init
        super.init()
    }

    public convenience init(_ paths: [String]) {
        self.init()
        self.watchingPaths = paths
    }

    // MARK: - API public methods

    open func watch(_ changeCb: (([FileEvent]) -> Void)?) {
        guard let paths = watchingPaths else {
            return
        }

        guard stream == nil else {
            return
        }

        onChangeCallback = changeCb

        var context = FSEventStreamContext(version: 0, info: UnsafeMutableRawPointer(mutating: Unmanaged.passUnretained(self).toOpaque()), retain: nil, release: nil, copyDescription: nil)
        stream = FSEventStreamCreate(kCFAllocatorDefault, innerEventCallback, &context, paths as CFArray, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents))
        FSEventStreamScheduleWithRunLoop(stream!, RunLoop.current.getCFRunLoop(), CFRunLoopMode.defaultMode.rawValue)
        FSEventStreamStart(stream!)
    }

    open func resume() {
        guard stream != nil else {
            return
        }

        FSEventStreamStart(stream!)
    }

    open func pause() {
        guard stream != nil else {
            return
        }

        FSEventStreamStop(stream!)
    }

    // MARK: - [Private] Closure passed into `FSEventStream` and is called on new file event

    fileprivate let innerEventCallback: FSEventStreamCallback = { (stream, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in
        let eventIds = eventIds
        let eventFlags = eventFlags
        let fsWatcher: SwiftFSWatcher = unsafeBitCast(contextInfo, to: SwiftFSWatcher.self)
        let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]

        var fileEvents = [FileEvent]()
        for i in 0..<numEvents {
            let event = FileEvent(path: paths[i], flag: eventFlags[i], id: eventIds[i])

            fileEvents.append(event)
        }

        fsWatcher.onChangeCallback?(fileEvents)
    }
}

@objc open class FileEvent : NSObject {

    open var eventPath: String!
    open var eventFlag: NSNumber!
    open var eventId: NSNumber!

    public init(path: String!, flag: UInt32!, id: UInt64!) {
        eventPath = path
        eventFlag = NSNumber(value: flag)
        eventId = NSNumber(value: id)
    }
}
