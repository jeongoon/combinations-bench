package main

import "testing"

/* my own module for go lang */
import jeongoon "github.com/jeongoon/go-combinations"

/* from `nonil`
  * https://github.com/notnil/combos#readme
 */
import notnil "github.com/notnil/combos"

/* test with :

   sh> go get -u "github.com/notnil/combos"
   sh> go test -bench=.

   please read: README.org

 */
func Benchmark_warmingup_notnil(b *testing.B) {
	m := 20

	for i := 1; i <= m; i++ {
		_ = notnil.New( m, i )
	}
}

func Benchmark_notnil10x2000(b *testing.B) {
	m := 10
	o := 2000

	for j := 0; j < o; j ++ {
		for i := 1; i <= m; i++ {
			_ = notnil.New( m, i )
		}
	}
}

func Benchmark_notnil15x200(b *testing.B) {
	m := 15
	o := 200

	for j := 0; j < o; j ++ {
		for i := 1; i <= m; i++ {
			_ = notnil.New( m, i )
		}
	}
}

func Benchmark_warmingup_jeongoon(b *testing.B) {
	m := 20

	_  = jeongoon.AllIndexes( m )

}

func Benchmark_jeongoon10x2000(b *testing.B) {
	m := 10
        o := 2000

	for j := 0; j < o; j ++ {
		for i := 1; i <= m; i++ {
			_ = jeongoon.SomeIndexes( m, i )
		}
	}
}

func Benchmark_jeongoon15x200(b *testing.B) {
	m := 15
	o := 200

	for j := 0; j < o; j ++ {
		for i := 1; i <= m; i++ {
			_ = jeongoon.SomeIndexes( m, i )
		}
	}
}

/* last test tends to finish late on my machine
 * so one more test for more accurate result */
func Benchmark_outro_notnil(b *testing.B) {
	m := 20

	for i := 1; i <= m; i++ {
		_ = notnil.New( m, i )
	}
}
