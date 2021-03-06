﻿

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Сообщение++
	КорневыеЭлементы = Объект.СодержаниеСообщения.НайтиСтроки(Новый Структура("ИДРодителя", 0));
	ЭлементыДерева = СодержаниеВВидеДерева.ПолучитьЭлементы();
	ЗаполнитьДеревоВДокументе(ЭлементыДерева, КорневыеЭлементы);
	//Сообщение--
	
	//Запрос обратного вызова++
	КорневыеЭлементы = Объект.СодержаниеЗапросаОбратногоВызова.НайтиСтроки(Новый Структура("ИДРодителя", 0));
	ЭлементыДерева = ЗапросОбратногоВызоваВВидеДерева.ПолучитьЭлементы();
	ЗаполнитьЗапросОбратногоВызоваВВидеДерева(ЭлементыДерева, КорневыеЭлементы);
	//Запрос обратного вызова--

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоВДокументе(ЭлементРодитель, Коллекция)
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл		
		нСтрока = ЭлементРодитель.Добавить();
		нСтрока.Ключ = ЭлементКоллекции.Ключ;
		нСтрока.Значение = ЭлементКоллекции.Значение;
		
		ДочернииОбъекты = Объект.СодержаниеСообщения.НайтиСтроки(Новый Структура("ИДРодителя", ЭлементКоллекции.ИДСтроки));
		ЗаполнитьДеревоВДокументе(нСтрока.ПолучитьЭлементы(), ДочернииОбъекты);		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗапросОбратногоВызоваВВидеДерева(ЭлементРодитель, Коллекция)
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл		
		нСтрока = ЭлементРодитель.Добавить();
		нСтрока.Ключ = ЭлементКоллекции.Ключ;
		нСтрока.Значение = ЭлементКоллекции.Значение;
		
		ДочернииОбъекты = Объект.СодержаниеЗапросаОбратногоВызова.НайтиСтроки(Новый Структура("ИДРодителя", ЭлементКоллекции.ИДСтроки));
		ЗаполнитьЗапросОбратногоВызоваВВидеДерева(нСтрока.ПолучитьЭлементы(), ДочернииОбъекты);		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отбор = СписокВложений.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сообщение");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;	
	Отбор.ПравоеЗначение = Объект.Ссылка;
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	Отбор.Использование = Истина;

КонецПроцедуры

