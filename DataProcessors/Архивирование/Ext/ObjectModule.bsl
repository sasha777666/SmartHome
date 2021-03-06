﻿
Процедура ПроцессДляСервера(Процесс = "") Экспорт // Записывается в процессы НазваниеПроцедуры
	
	Инициализация();		
	ВыполнитьАрхивирование();	
	
КонецПроцедуры

Процедура Инициализация()Экспорт
	
	КаталогВременныхФайлов = КаталогВременныхФайлов();
	Попытка
		ZIPexe = КаталогВременныхФайлов + "7za.exe";
		
		// Сохраняем файл 7za.exe
		Макет = ПолучитьМакет("zip");
		Макет.Записать(ZIPexe);
		ПутьZIPexe = ZIPexe;		
	Исключение
		Сообщения = Сообщения + "Ошибка сохранения файла: 7za.exe в каталог: " + КаталогВременныхФайлов + Символы.ПС;
		ПутьZIPexe = "";
		Возврат;
	КонецПопытки;

	
	Ответ = ЗаполнитьНастройки();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
КонецПроцедуры

Функция  ЗаполнитьНастройки() Экспорт
	
	СообщениеСНенайденнымиНастройками = "";
	
	// Настройки табличной части
	Задания.Очистить(); // Очищаем предыдущие данные если обработка уже была открыта
	СтрокаСТабСНастройкамиРеквизитов = Оборудование.Настройки.Найти("Задания",  "Наименование");
	Если СтрокаСТабСНастройкамиРеквизитов = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка для ТЧ ""Задания"" (В справочнике оборудование); ";
	Иначе
		ТабСНастройкамиСтрок = СтрокаСТабСНастройкамиРеквизитов.Настройка.ТаблицаНастроек;
		
		Для Каждого НстрокаСтроки Из ТабСНастройкамиСтрок Цикл
			нСтрока = Задания.Добавить();			
			ТабСНастройкамиСтроки = НстрокаСтроки.Значение.ТаблицаНастроек;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("ПутьИсточник", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""ПутьИсточник""; ";
			Иначе
				нСтрока.ПутьИсточник = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("ПутьИсточникОтносительноРабочейПапки", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный, по умолчанию Ложь (Путь абсолютный)
			Иначе
				нСтрока.ПутьИсточникОтносительноРабочейПапки = СтрокаСПараметром.Значение;
			КонецЕсли;

			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("ПутьНазначения", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""ПутьНазначения""; ";
			Иначе
				нСтрока.ПутьНазначения = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("ПутьНазначенияОтносительноРабочейПапки", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный, по умолчанию Ложь (Путь абсолютный)
			Иначе
				нСтрока.ПутьНазначенияОтносительноРабочейПапки = СтрокаСПараметром.Значение;
			КонецЕсли;


			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("СтепеньСжатия", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный, по умолчанию 0 (Число: 0,1,3,5,7,9)
			Иначе
				нСтрока.СтепеньСжатия = СтрокаСПараметром.Значение;
			КонецЕсли;

			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("УдалятьПослеОбработки", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный, по умолчанию Ложь
			Иначе
				нСтрока.УдалятьПослеОбработки = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("ГруппаУсловий", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный
			Иначе
				нСтрока.ГруппаУсловий = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("СпособОбработки", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный
			Иначе
				нСтрока.СпособОбработки = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("МаксимальныйРазмерПапкиНазначенияВМегабайтах", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный
			Иначе
				нСтрока.МаксимальныйРазмерПапкиНазначенияВМегабайтах = СтрокаСПараметром.Значение;
			КонецЕсли;
			
			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("УдалятьСтарыеФайлыВПапкеНазначения", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный
			Иначе
				нСтрока.УдалятьСтарыеФайлыВПапкеНазначения = СтрокаСПараметром.Значение;
			КонецЕсли;

			СтрокаСПараметром = ТабСНастройкамиСтроки.Найти("СпособОпределенияСтарыхФайловВПапкеНазначения", "Параметр");
			Если СтрокаСПараметром = Неопределено Тогда 
				//Ничего не делаем, параметр не обязательный
			Иначе
				нСтрока.СпособОпределенияСтарыхФайловВПапкеНазначения = СтрокаСПараметром.Значение;
			КонецЕсли;

	
		КонецЦИкла;	
		
	КонецЕсли;
		
	Возврат СообщениеСНенайденнымиНастройками;	

КонецФункции


Процедура ВыполнитьАрхивирование()Экспорт
	
	Для Каждого Задание Из Задания Цикл
		Если СерверПривилегированный.ПроверкаГруппыУсловий(Задание.ГруппаУсловий) = Истина Тогда 
			Если Задание.СпособОбработки = "ПериодическиеПапкиГодМесяцДень" Тогда 
				СпособОбработкиПериодическиеПапкиГодМесяцДень(Задание);	
			ИначеЕсли Задание.СпособОбработки = "ПериодическиеПапкиГодГодМесяцДень" Тогда 
				СпособОбработкиПериодическиеПапкиГодГодМесяцДень(Задание);
			Иначе
				СпособОбработкиУниверсальный(Задание);
			КонецЕсли;		
		КонецЕсли;							
	КонецЦикла;
			
КонецПроцедуры


Процедура СпособОбработкиУниверсальный(Задание)
	
КонецПроцедуры


Процедура СпособОбработкиПериодическиеПапкиГодМесяцДень(Задание)
	
	РабочаяПапка = Константы.КаталогФайловРабочий.Получить();
	Если Задание.ПутьИсточникОтносительноРабочейПапки Тогда 
		ПолныйПутьИсточник = "" + РабочаяПапка + Задание.ПутьИсточник;
	Иначе
		ПолныйПутьИсточник = "" + Задание.ПутьИсточник;	
	КонецЕсли;
	Если Задание.ПутьНазначенияОтносительноРабочейПапки Тогда 
		ПолныйПутьНазначения = "" + РабочаяПапка + Задание.ПутьНазначения; 
	Иначе
		ПолныйПутьНазначения = "" + Задание.ПутьНазначения;	
	КонецЕсли;
	
	
	//ПодпапкиДляОбработки = Новый Массив();
	ИсточникУровень1ГодМесяцДень = НайтиФайлы(ПолныйПутьИсточник, "*", Ложь);
	Для Каждого Элемент1у Из ИсточникУровень1ГодМесяцДень Цикл
		Если Элемент1у.Расширение = "" Тогда 
			Попытка
				ПапкаТекущегоДня = Дата(СтрЗаменить(Элемент1у.Имя,"-","")) = НачалоДня(ТекущаяДата());
			Исключение
				Продолжить; // посторонняя папка
			КонецПопытки;
			Если ПапкаТекущегоДня Тогда 
				Продолжить; // Не обрабатываем данные текущего дня
			КонецЕсли;
			ПутьКАрхиву = ДобавитьВАрхив(ПолныйПутьИсточник+"\"+Элемент1у.Имя, Элемент1у.Имя, Задание.СтепеньСжатия);
			Если ПутьКАрхиву <> "" Тогда // Успешно создан архив	
				ФайлПеремещён = ПереместитьАрхивВМестоНазначения(Задание, ПутьКАрхиву, ПолныйПутьНазначения, Элемент1у.Имя+".7z");
				Если Задание.УдалятьПослеОбработки И ФайлПеремещён Тогда  // удалим исходную папку
					УдалитьФайлы(ПолныйПутьИсточник+"\"+Элемент1у.Имя);	
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
						
		
КонецПроцедуры

Процедура СпособОбработкиПериодическиеПапкиГодГодМесяцДень(Задание)
	
	РабочаяПапка = Константы.КаталогФайловРабочий.Получить();
	Если Задание.ПутьИсточникОтносительноРабочейПапки Тогда 
		ПолныйПутьИсточник = "" + РабочаяПапка + Задание.ПутьИсточник;
	Иначе
		ПолныйПутьИсточник = "" + Задание.ПутьИсточник;	
	КонецЕсли;
	Если Задание.ПутьНазначенияОтносительноРабочейПапки Тогда 
		ПолныйПутьНазначения = "" + РабочаяПапка + Задание.ПутьНазначения; 
	Иначе
		ПолныйПутьНазначения = "" + Задание.ПутьНазначения;	
	КонецЕсли;
	
	
	//ПодпапкиДляОбработки = Новый Массив();
	ИсточникУровень1Год = НайтиФайлы(ПолныйПутьИсточник, "*", Ложь);
	Для Каждого Элемент1у Из ИсточникУровень1Год Цикл
		Если Элемент1у.Расширение = "" Тогда 
			БылоУдалениеВложенныхПапок = Ложь;
			ИсточникУровень2ГодМесяцДень = НайтиФайлы(ПолныйПутьИсточник+"\"+Элемент1у.Имя, "*", Ложь);
			Для Каждого Элемент2у Из ИсточникУровень2ГодМесяцДень Цикл
				Если Элемент2у.Расширение = "" Тогда 
					Попытка
						ПапкаТекущегоДня = Дата(СтрЗаменить(Элемент2у.Имя,"-","")) = НачалоДня(ТекущаяДата());
					Исключение
						Продолжить; // посторонняя папка
					КонецПопытки;
					Если ПапкаТекущегоДня Тогда 
						Продолжить; // Не обрабатываем данные текущего дня
					КонецЕсли;
					ПутьКАрхиву = ДобавитьВАрхив(ПолныйПутьИсточник+"\"+Элемент1у.Имя+"\"+Элемент2у.Имя, Элемент2у.Имя, Задание.СтепеньСжатия);
					Если ПутьКАрхиву <> "" Тогда // Успешно создан архив	
						ФайлПеремещён = ПереместитьАрхивВМестоНазначения(Задание, ПутьКАрхиву, ПолныйПутьНазначения+"\"+Элемент1у.Имя, Элемент2у.Имя+".7z");
						Если Задание.УдалятьПослеОбработки И ФайлПеремещён Тогда  // удалим исходную папку
							УдалитьФайлы(ПолныйПутьИсточник+"\"+Элемент1у.Имя+"\"+Элемент2у.Имя);	
							БылоУдалениеВложенныхПапок = Истина;
						КонецЕсли;
					КонецЕсли;	
				КонецЕсли;
			КонецЦикла;	
			КаталогПервогоУровняПуст = НайтиФайлы(ПолныйПутьИсточник+"\"+Элемент1у.Имя, "*", Ложь).Количество() = 0;
			Если БылоУдалениеВложенныхПапок И КаталогПервогоУровняПуст Тогда //Удаляем каталог первого уровня
				УдалитьФайлы(ПолныйПутьИсточник+"\"+Элемент1у.Имя);	
			КонецЕсли;			
		КонецЕсли;			
	КонецЦикла;	
	
КонецПроцедуры

Функция ДобавитьВАрхив(ПутьИсточник, ИмяАрихива, СтепеньСжатия)
	
	Ответ = "";
	
	ФайлАрихива = КаталогВременныхФайлов() + ИмяАрихива + ".7z";
	Попытка
		СтрокаЗапуска = "" + ПутьZIPexe + " a" +  " -mx" + СтепеньСжатия + " " + """" + ФайлАрихива + """ """ + ПутьИсточник + """";
		WshShell=Новый COMОбъект("Wscript.Shell");
    	Результат = WshShell.run(СтрокаЗапуска,0,1);
		Ответ = ФайлАрихива;
	Исключение
		ОписаниеОшибки = "Ошибка при создании архива. Описание ошибки: " + ОписаниеОшибки();
		Сообщения = Сообщения + ОписаниеОшибки + Символы.ПС;		
	КонецПопытки;
		
	Возврат Ответ;
	
КонецФункции

Функция ПереместитьАрхивВМестоНазначения(Задание, ПутьАрхива, МестоНазначения, ИмяФайлаВПапкеНазначения)
	
	Ответ = Ложь;
	
	Попытка 
		СоздатьКаталог(МестоНазначения);
		Если ЗначениеЗаполнено(Задание.МаксимальныйРазмерПапкиНазначенияВМегабайтах) Тогда
			
			РазмерПапки = ОбщегоНазначения.ОпределитьРазмерФайлаКаталога(МестоНазначения);	
			ФайлАрхива =  Новый Файл(ПутьАрхива);
			РазмерАрхива = ФайлАрхива.Размер();	
			ПредпологаемыйРазмерПапкиМБ = (РазмерПапки + РазмерАрхива)/1048576;
			
			Если ПредпологаемыйРазмерПапкиМБ > Задание.МаксимальныйРазмерПапкиНазначенияВМегабайтах Тогда
				// новый архив не вмещается в папку, проверим можно ли удалить старые файлы	
				Если Задание.УдалятьСтарыеФайлыВПапкеНазначения = Истина Тогда 	
					//Сортируем по Способу определения старых файлов
					Если Задание.СпособОпределенияСтарыхФайловВПапкеНазначения = "ПоИмени" Тогда
						НайденныеФайлы = НайтиФайлы(МестоНазначения, "*.*", Ложь);
						ТаблицаСФайлами = Новый ТаблицаЗначений();
						ТаблицаСФайлами.Колонки.Добавить("ИмяФайла");
						ТаблицаСФайлами.Колонки.Добавить("Файл");
						Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
							нСтрока = ТаблицаСФайлами.Добавить();
							нСтрока.ИмяФайла = НайденныйФайл.Имя;
							нСтрока.Файл = НайденныйФайл;
						КонецЦикла;
						ТаблицаСФайлами.Сортировать("ИмяФайла");
						Пока ПредпологаемыйРазмерПапкиМБ > Задание.МаксимальныйРазмерПапкиНазначенияВМегабайтах И ТаблицаСФайлами.Количество() > 0 Цикл
							ПредпологаемыйРазмерПапкиМБ = ПредпологаемыйРазмерПапкиМБ - (ТаблицаСФайлами[0].Файл.Размер()/1048576);	
							УдалитьФайлы(ТаблицаСФайлами[0].Файл.ПолноеИмя);
							ТаблицаСФайлами.Удалить(ТаблицаСФайлами[0]);
						КонецЦикла;
						Если ПредпологаемыйРазмерПапкиМБ > Задание.МаксимальныйРазмерПапкиНазначенияВМегабайтах Тогда
							ОписаниеОшибки = "Не удалось переместить архив, возможно размер архива превышает Макс. размер каталога (Настраивается в Архивировании)";
							Сообщения = Сообщения + ОписаниеОшибки + Символы.ПС;
							Ответ = Ложь;
						Иначе
							ПереместитьФайл(ПутьАрхива, МестоНазначения+"\"+ИмяФайлаВПапкеНазначения);
							Ответ = Истина; 
	                   	КонецЕсли;
					Иначе
						//Тут могут быть другие способы
						Ответ = Ложь;
					КонецЕсли;					
				Иначе //Если СтарыеФайлы удалять нельзя то не копируем наш архив и возвращаем Ложь
					ОписаниеОшибки = "Не удалось переместить архив, достигнуто ограничение по Макс. размеру каталога (Настраивается в Архивировании)";
					Сообщения = Сообщения + ОписаниеОшибки + Символы.ПС;
					Ответ = Ложь; 
				КонецЕсли;
			Иначе // Перемещаем			
				ПереместитьФайл(ПутьАрхива, МестоНазначения+"\"+ИмяФайлаВПапкеНазначения);
				Ответ = Истина; 
			КонецЕсли;
			
		Иначе// Перемещаем			
			ПереместитьФайл(ПутьАрхива, МестоНазначения+"\"+ИмяФайлаВПапкеНазначения);	
			Ответ = Истина; 
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки = "Ошибка при перемещении архива. Описание ошибки: " + ОписаниеОшибки();
		Сообщения = Сообщения + ОписаниеОшибки + Символы.ПС;
	КонецПопытки;	
	
	Возврат Ответ;
	
КонецФункции


