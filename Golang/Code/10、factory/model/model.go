package model

import (
	"fmt"
)

type Student struct {
	Name  string
	Age   int
	score int
}

type teacher struct {
	name string
	age  int
}

func (student *Student) SetScore(score int) {
	if score <= 0 || score > 100 {
		fmt.Println("请输入正确的分数")
	} else {
		student.score = score
	}
}

func (student *Student) GetScore() int {
	return student.score
}

func NewTeacher(name string, age int) *teacher {
	if age <= 0 || age > 100 {
		fmt.Println("请输入正确的年纪")
		return nil
	}
	return &teacher{
		name: name,
		age:  age,
	}
}

func (t *teacher) SetName(name string) {
	t.name = name
}

func (t *teacher) GetName() string {
	return t.name
}
