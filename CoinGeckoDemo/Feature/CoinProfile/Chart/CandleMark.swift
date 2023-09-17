import SwiftUI
import Charts

struct CandleMark<X: Plottable, Y: Plottable>: ChartContent {
    let time: PlottableValue<X>
    let low: PlottableValue<Y>
    let high: PlottableValue<Y>
    let open: PlottableValue<Y>
    let close: PlottableValue<Y>
    let width: MarkDimension
    
    init(
        time: PlottableValue<X>,
        low: PlottableValue<Y>,
        high: PlottableValue<Y>,
        open: PlottableValue<Y>,
        close: PlottableValue<Y>,
        width: MarkDimension
    ) {
        self.time = time
        self.low = low
        self.high = high
        self.open = open
        self.close = close
        self.width = width
    }
    
    var body: some ChartContent {
        RectangleMark(x: time, yStart: low, yEnd: high, width: 1)
        RectangleMark(x: time, yStart: open, yEnd: close, width: width)
    }
}
