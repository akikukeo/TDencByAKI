LoadPlugin("ffms2.dll")

fps_num = Int(30.000 * 1000)
FFVideoSource("C:\Users\ishii\Downloads\新しいフォルダー\hjjgsskftjhthhtth.mp4",cachefile="input.ffindex",seekmode=1,threads=1)


ConvertToYV12(interlaced=false)



LoadPlugin("RemoveGrain.dll")
LoadPlugin("Repair.dll")
src=last
blur=src.RemoveGrain(5)
last=Repair(blur, src)

return last
