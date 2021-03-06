﻿
&НаСервере
Процедура УдалитьВсеЗаписиИзРегистраСведенийИсторияДанныеОборудованияНаСервере()
	РегистрыСведений.ИсторияДанныеОборудования.СоздатьНаборЗаписей().Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеЗаписиИзРегистраСведенийИсторияДанныеОборудования(Команда)
	УдалитьВсеЗаписиИзРегистраСведенийИсторияДанныеОборудованияНаСервере();
КонецПроцедуры

&НаСервере
Процедура УдалитьВсеЗаписиИзРегистраСведенийЖурналОшибокНаСервере()
	РегистрыСведений.ЖурналОшибок.СоздатьНаборЗаписей().Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеЗаписиИзРегистраСведенийЖурналОшибок(Команда)
	УдалитьВсеЗаписиИзРегистраСведенийЖурналОшибокНаСервере();
КонецПроцедуры

&НаСервере
Процедура СвернутьИсториюОборудованияПоЧасамНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.Текст ="ВЫБРАТЬ
	              |	ИсторияДанныеОборудования.Оборудование КАК Оборудование,
	              |	ИсторияДанныеОборудования.ОбъектДанных КАК ОбъектДанных,
	              |	НАЧАЛОПЕРИОДА(ИсторияДанныеОборудования.Период, ЧАС) КАК Час,
	              |	МИНИМУМ(ИсторияДанныеОборудования.Данные) КАК Минимум,
	              |	СРЕДНЕЕ(ИсторияДанныеОборудования.Данные) КАК Среднее,
	              |	МАКСИМУМ(ИсторияДанныеОборудования.Данные) КАК Максимум
	              |ИЗ
	              |	РегистрСведений.ИсторияДанныеОборудования КАК ИсторияДанныеОборудования
	              |ГДЕ
	              |	ИсторияДанныеОборудования.Период >= &ДатаНачала
	              |	И ИсторияДанныеОборудования.Период <= &ДатаКонца
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	ИсторияДанныеОборудования.Оборудование,
	              |	ИсторияДанныеОборудования.ОбъектДанных,
	              |	НАЧАЛОПЕРИОДА(ИсторияДанныеОборудования.Период, ЧАС)
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	Час,
	              |	Оборудование,
	              |	ОбъектДанных
	              |ИТОГИ ПО
	              |	Час,
	              |	Оборудование,
	              |	ОбъектДанных";
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКонца", ДатаКонца);
	ВыборкаЧас = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ИндикаторШаг = 10000 / ВыборкаЧас.Количество();	
	ИндикаторТекЗначение = 0;
	
	Пока ВыборкаЧас.Следующий() Цикл
		ВыборкаОборудование = ВыборкаЧас.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОборудование.Следующий() Цикл
			ВыборкаОбъект = ВыборкаОборудование.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);			
			Пока ВыборкаОбъект.Следующий() Цикл
				
				ЗапросДанных  = Новый Запрос();
				ЗапросДанных.Текст = "ВЫБРАТЬ
				                     |	ИсторияДанныеОборудования.Период КАК Период,
				                     |	ИсторияДанныеОборудования.Оборудование,
				                     |	ИсторияДанныеОборудования.ОбъектДанных,
				                     |	ИсторияДанныеОборудования.Данные
				                     |ИЗ
				                     |	РегистрСведений.ИсторияДанныеОборудования КАК ИсторияДанныеОборудования
				                     |ГДЕ
				                     |	ИсторияДанныеОборудования.Оборудование = &Оборудование
				                     |	И ИсторияДанныеОборудования.ОбъектДанных = &ОбъектДанных
				                     |	И ИсторияДанныеОборудования.Период >= &ПериодНач
				                     |	И ИсторияДанныеОборудования.Период <= &ПериодКон
				                     |
				                     |УПОРЯДОЧИТЬ ПО
				                     |	Период";
				ЗапросДанных.УстановитьПараметр("Оборудование", ВыборкаОбъект.Оборудование);
				ЗапросДанных.УстановитьПараметр("ОбъектДанных", ВыборкаОбъект.ОбъектДанных);
				ЗапросДанных.УстановитьПараметр("ПериодНач", ВыборкаОбъект.Час);
				ЗапросДанных.УстановитьПараметр("ПериодКон", ВыборкаОбъект.Час+3599);
				ВыборкаДанные = ЗапросДанных.Выполнить().Выбрать();
								
				ОбработатьМин = Истина;
				ОбработатьСред = Истина;
				ОбработатьМакс = Истина;
				ДатаМин = '00010101';
				ДатаМакс = '00010101';
				Пока ВыборкаДанные.Следующий() Цикл
					
					Если ОбработатьМин И ВыборкаДанные.Данные = ВыборкаОбъект.Минимум Тогда	
						ДатаМин = ВыборкаДанные.Период; 
						ОбработатьМин = Ложь;
						Продолжить; // Оставляем запись
					КонецЕсли;
					Если ОбработатьМакс И ВыборкаДанные.Данные = ВыборкаОбъект.Максимум Тогда	
						ДатаМакс = ВыборкаДанные.Период;  
						ОбработатьМакс = Ложь;
						Продолжить; // Оставляем запись
					КонецЕсли;
					// оставляем только 2 записи на час, мин и макс, остальные удаляем
					МенеджерЗаписи = РегистрыСведений.ИсторияДанныеОборудования.СоздатьМенеджерЗаписи();
					МенеджерЗаписи.Оборудование = ВыборкаДанные.Оборудование;
					МенеджерЗаписи.ОбъектДанных = ВыборкаДанные.ОбъектДанных;
					МенеджерЗаписи.Период = ВыборкаДанные.Период;
					МенеджерЗаписи.Прочитать();
					МенеджерЗаписи.Удалить();
					
				КонецЦикла;
				//Создадим запись для среднего
				МенеджерЗаписи = РегистрыСведений.ИсторияДанныеОборудования.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Оборудование = ВыборкаОбъект.Оборудование;
				МенеджерЗаписи.ОбъектДанных = ВыборкаОбъект.ОбъектДанных;
				ДатаЗаписиСред = ВыборкаОбъект.Час; // Определим свободный период для записи среднего значения за час
				Пока ДатаЗаписиСред = ДатаМин или ДатаЗаписиСред = ДатаМакс Цикл
					ДатаЗаписиСред = ДатаЗаписиСред + 1;
				КонецЦикла;			
				МенеджерЗаписи.Период = ДатаЗаписиСред;
				МенеджерЗаписи.Данные = ВыборкаОбъект.Среднее;
				МенеджерЗаписи.Записать(Истина);				
	
			КонецЦикла;
		КонецЦикла;
		ИндикаторТекЗначение = ИндикаторТекЗначение + ИндикаторШаг;
		//Если будет способ показывать состояние то вставить код тут
	КонецЦикла;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьИсториюОборудованияПоЧасам(Команда)
	СвернутьИсториюОборудованияПоЧасамНаСервере();
КонецПроцедуры
