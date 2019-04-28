!INTERFILE  :=
!imaging modality := nucmed
!version of keys := 3.3
name of data file := my_input.s
;data offset in bytes := 0

!GENERAL IMAGE DATA :=
!type of data := Tomographic
imagedata byte order := LITTLEENDIAN
!number format := unsigned integer
!number of bytes per pixel := 2
!data starting block := 0

!SPECT STUDY (General) := 
;number of dimensions := 2
;matrix axis label [2] := axial coordinate
!matrix size [2] := 128
!scaling factor (mm/pixel) [2] := 2.5
;matrix axis label [1] := bin coordinate
!matrix size [1] := 128
!scaling factor (mm/pixel) [1] := 2.5
!number of projections := 144
!extent of rotation := 360
!process status := acquired

!SPECT STUDY (acquired data) :=
!direction of rotation := CW
start angle := 0
orbit := circular
radius := 230

!END OF INTERFILE :=
