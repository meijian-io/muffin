## muffin
   **Multiple Flutters In**，基于Flutter2.0多Engine、Navigator2.0实现的一套混合栈管理方案。
   与单Engine的本质区别在于，单Engine模式下pop或者push操作的是同一个Flutter路由，同一个Engine需要attach到不同的FlutterVC上，导致混合栈维护复杂。
   多Engine模式下，Engine是底层spwan的，一个FlutterVC对应一个Engine，每一个FlutterVC中的Flutter路由保证独立，混合栈维护简单，可以实现类似popUntil的功能。

