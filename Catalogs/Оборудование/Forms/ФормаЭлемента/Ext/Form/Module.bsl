﻿

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отбор = ПроцессыОбъекта.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Оборудование");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;	
	Отбор.ПравоеЗначение = Объект.Ссылка;
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	Отбор.Использование = Истина;

	

КонецПроцедуры
