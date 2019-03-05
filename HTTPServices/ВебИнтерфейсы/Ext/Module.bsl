
Функция КамерыМетод1(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "text/html");

	ТелоОтвета = "<head>
					|<script language=""JavaScript""><!--
					|  function refreshIt() {
					|    if (!document.images) return;
					|      document.images['myCam'].src = ""http://192.168.1.13/image.jpg?cachebust="" + Math.round(1000000+(Math.random() * 1000000))+""&a=0"";
					|      setTimeout('refreshIt()',200); // refresh every 200ms
					| }
					|
					|  //--></script>
					|</head>
					|
					|<body onLoad="" setTimeout('refreshIt()',200)"">
					|
					|<img src=""http://192.168.1.13/image.jpg"" name=""myCam"">
					|
					|</body>";		
	Ответ.УстановитьТелоИзСтроки(ТелоОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
				
	Возврат Ответ;
	
КонецФункции
