import SwiftUI

@Observable class CountdownTimer {
    
    public  var remainingTime : Int
    private var timer         : Timer?
    private var action        : () -> Void
    
    init ( duration: Int, action: @escaping () -> Void ) {
        self.remainingTime = duration
        self.action        = action
    } 
    
    func begin () {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                timer.invalidate()
                self.action()
            }
        }
    }
    
    func end () {
        timer?.invalidate()
        timer = nil
    }
    
}
