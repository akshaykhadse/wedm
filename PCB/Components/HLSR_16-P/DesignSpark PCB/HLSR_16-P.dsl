SamacSys ECAD Model
545509/30955/2.18/10/4/Undefined or Miscellaneous

DESIGNSPARK_INTERMEDIATE_ASCII

(asciiHeader
	(fileUnits MM)
)
(library Library_1
	(padStyleDef "c310_h175"
		(holeDiam 1.75)
		(padShape (layerNumRef 1) (padShapeType Ellipse)  (shapeWidth 3.1) (shapeHeight 3.1))
		(padShape (layerNumRef 16) (padShapeType Ellipse)  (shapeWidth 3.1) (shapeHeight 3.1))
	)
	(padStyleDef "c190_h115"
		(holeDiam 1.15)
		(padShape (layerNumRef 1) (padShapeType Ellipse)  (shapeWidth 1.9) (shapeHeight 1.9))
		(padShape (layerNumRef 16) (padShapeType Ellipse)  (shapeWidth 1.9) (shapeHeight 1.9))
	)
	(textStyleDef "Default"
		(font
			(fontType Stroke)
			(fontFace "Helvetica")
			(fontHeight 50 mils)
			(strokeWidth 5 mils)
		)
	)
	(patternDef "HLSR16-P" (originalName "HLSR16-P")
		(multiLayer
			(pad (padNum 1) (padStyleRef c190_h115) (pt 3.09, -17.2) (rotation 90))
			(pad (padNum 2) (padStyleRef c190_h115) (pt 4.36, -19.4) (rotation 90))
			(pad (padNum 3) (padStyleRef c190_h115) (pt 5.63, -17.2) (rotation 90))
			(pad (padNum 4) (padStyleRef c190_h115) (pt 6.9, -19.4) (rotation 90))
			(pad (padNum 5) (padStyleRef c310_h175) (pt 15.5, -9.43) (rotation 90))
			(pad (padNum 6) (padStyleRef c310_h175) (pt 15.5, -6.89) (rotation 90))
			(pad (padNum 7) (padStyleRef c310_h175) (pt 15.5, -4.35) (rotation 90))
			(pad (padNum 8) (padStyleRef c310_h175) (pt -5.5, -4.35) (rotation 90))
			(pad (padNum 9) (padStyleRef c310_h175) (pt -5.5, -6.89) (rotation 90))
			(pad (padNum 10) (padStyleRef c310_h175) (pt -5.5, -9.43) (rotation 90))
		)
		(layerContents (layerNumRef 18)
			(attr "RefDes" "RefDes" (pt 4.582, -10) (textStyleRef "Default") (isVisible True))
		)
		(layerContents (layerNumRef 28)
			(line (pt 0 0) (pt 10 0) (width 0.254))
		)
		(layerContents (layerNumRef 28)
			(line (pt 10 0) (pt 10 -19.4) (width 0.254))
		)
		(layerContents (layerNumRef 28)
			(line (pt 10 -19.4) (pt 0 -19.4) (width 0.254))
		)
		(layerContents (layerNumRef 28)
			(line (pt 0 -19.4) (pt 0 0) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(line (pt 0 -19.4) (pt 0 0) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(line (pt 0 0) (pt 10 0) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(line (pt 10 0) (pt 10 -19.4) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(line (pt 0 -19.4) (pt 3.1 -19.4) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(line (pt 10 -19.4) (pt 8.171 -19.4) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(arc (pt -0.918, -16.376) (radius 0.14) (startAngle 0.0) (sweepAngle 0.0) (width 0.254))
		)
		(layerContents (layerNumRef 18)
			(arc (pt -0.918, -16.376) (radius 0.14) (startAngle 180.0) (sweepAngle 180.0) (width 0.254))
		)
	)
	(symbolDef "HLSR_16-P" (originalName "HLSR_16-P")

		(pin (pinNum 1) (pt 0 mils 0 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 175 mils 0 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))) (pinName (text (pt 225 mils -25 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))
		))
		(pin (pinNum 2) (pt 0 mils -100 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 175 mils -100 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))) (pinName (text (pt 225 mils -125 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))
		))
		(pin (pinNum 3) (pt 0 mils -200 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 175 mils -200 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))) (pinName (text (pt 225 mils -225 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))
		))
		(pin (pinNum 4) (pt 0 mils -300 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 175 mils -300 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))) (pinName (text (pt 225 mils -325 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))
		))
		(pin (pinNum 5) (pt 0 mils -400 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 175 mils -400 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))) (pinName (text (pt 225 mils -425 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))
		))
		(pin (pinNum 6) (pt 900 mils 0 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 725 mils 0 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))) (pinName (text (pt 700 mils -25 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))
		))
		(pin (pinNum 7) (pt 900 mils -100 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 725 mils -100 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))) (pinName (text (pt 700 mils -125 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))
		))
		(pin (pinNum 8) (pt 900 mils -200 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 725 mils -200 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))) (pinName (text (pt 700 mils -225 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))
		))
		(pin (pinNum 9) (pt 900 mils -300 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 725 mils -300 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))) (pinName (text (pt 700 mils -325 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))
		))
		(pin (pinNum 10) (pt 900 mils -400 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinDes (text (pt 725 mils -400 mils) (rotation 0) (justify "Left") (textStyleRef "Default"))) (pinName (text (pt 700 mils -425 mils) (rotation 0) (justify "Right") (textStyleRef "Default"))
		))

		(line (pt 200 mils 100 mils) (pt 700 mils 100 mils) (width 10 mils))
		(line (pt 700 mils 100 mils) (pt 700 mils -500 mils) (width 10 mils))
		(line (pt 700 mils -500 mils) (pt 200 mils -500 mils) (width 10 mils))
		(line (pt 200 mils -500 mils) (pt 200 mils 100 mils) (width 10 mils))

		(attr "RefDes" "RefDes" (pt 750 mils 350 mils) (isVisible True) (textStyleRef "Default"))

	)

	(compDef "HLSR_16-P" (originalName "HLSR_16-P") (compHeader (numPins 10) (numParts 1) (refDesPrefix U)
		)
		(compPin "1" (pinName "VREF") (partNum 1) (symPinNum 1) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "2" (pinName "VOUT") (partNum 1) (symPinNum 2) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "3" (pinName "GND") (partNum 1) (symPinNum 3) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "4" (pinName "+UC") (partNum 1) (symPinNum 4) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "5" (pinName "5") (partNum 1) (symPinNum 5) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "6" (pinName "6") (partNum 1) (symPinNum 6) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "7" (pinName "7") (partNum 1) (symPinNum 7) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "8" (pinName "8") (partNum 1) (symPinNum 8) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "9" (pinName "9") (partNum 1) (symPinNum 9) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(compPin "10" (pinName "10") (partNum 1) (symPinNum 10) (gateEq 0) (pinEq 0) (pinType Bidirectional))
		(attachedSymbol (partNum 1) (altType Normal) (symbolName "HLSR_16-P"))
		(attachedPattern (patternNum 1) (patternName "HLSR16-P")
			(numPads 10)
			(padPinMap
				(padNum 1) (compPinRef "1")
				(padNum 2) (compPinRef "2")
				(padNum 3) (compPinRef "3")
				(padNum 4) (compPinRef "4")
				(padNum 5) (compPinRef "5")
				(padNum 6) (compPinRef "6")
				(padNum 7) (compPinRef "7")
				(padNum 8) (compPinRef "8")
				(padNum 9) (compPinRef "9")
				(padNum 10) (compPinRef "10")
			)
		)
		(attr "Supplier_Name" "RS")
		(attr "RS Part Number" "")
		(attr "Manufacturer_Name" "LEM")
		(attr "Manufacturer_Part_Number" "HLSR 16-P")
		(attr "Allied_Number" "")
		(attr "Other Part Number" "")
		(attr "Description" "LEM - HLSR 16-P - CURRENT SENSOR, 16A, VOLTAGE O/P, 5VDC")
		(attr "Datasheet Link" "http://www.lem.com/docs/products/hlsr-p_series.pdf")
		(attr "3D Package" "")
	)

)
