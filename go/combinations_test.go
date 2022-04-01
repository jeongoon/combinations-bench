package main

import (
	"testing"
)

/* test with :

   sh> go test -bench=.

   test result not stable on my machine.
   but I found that some warming up code helps more accurate test

   jeongoon, notnil shows similar performance on M := (10 ~ 20)
   IMHO, my code(jeongoon) is tiny small slightly better on large selection.
*/

/* my own module for go lang */
/* copyright: Myoungjin Jeon <jeongoon@gmail.com> */
func jeongoon( M int, N int ) [][]int {
	// M: number of selection ( 0 ... (M-1) )
	// N: number of choice
	if M < N {
		return [][]int{}
	}

	initRoomSize := M - N
	room := make([]int, N)
	pos  := indexRange(N)
	// https://stackoverflow.com/questions/39984957/is-it-possible-to-initialize-slice-with-specific-values
	for i := range room {
		room[i] = initRoomSize
	}

	var combis [][]int
	new_case := make([]int, N)
	copy(new_case, pos)
	combis = append( [][]int{}, new_case )

	cursor := N - 1 // initial: index of last elements in selection

	for {
		if room[cursor] > 0 {
			room[cursor]--
			pos[cursor]++
			new_case := make([]int, N)
			copy(new_case, pos)
			combis = append(combis, new_case)
		} else {
			cursor_moved := false
			for i := cursor; i > 0; i-- {
				if room[i-1] > 0 {
					cursor = i-1
					cursor_moved = true
					break
				}
			}
			if cursor_moved {
				new_room := room[cursor] - 1
				base_pos := pos[cursor];
				for p, i := 1, cursor; i < N; i++ {
					room[i] = new_room
					pos[i]  = base_pos + p
					p++ // p++, i++ not working on for()
				}
				new_case := make([]int, N)
				copy(new_case, pos)
				combis = append(combis, new_case)
				cursor = N - 1
			} else {
				break
			}
		}

	}

	return combis
}


func notnil( n, k  int ) [][]int {
	results := [][]int{}
	if n <= 0 || k <= 0 || k > n {
		return results
	}
	pool := indexRange(n)
	indices := indexRange(k)
	result := indexRange(k)
	results = append(results, indexRange(k))
	for {
		i := k - 1
		for ; i >= 0 && indices[i] == i+len(pool)-k; i-- {
		}
		if i < 0 {
			break
		}
		indices[i]++
		for j := i + 1; j < k; j++ {
			indices[j] = indices[j-1] + 1
		}
		for ; i < len(indices); i++ {
			result[i] = pool[indices[i]]
		}
		resultCopy := make([]int, len(result))
		copy(resultCopy, result)
		results = append(results, resultCopy)
	}
	return results
}


func indexRange(n int) []int {
	r := []int{}
	for i :=0; i < n; i++ {
		r = append(r, i)
	}
	return r
}

func Benchmark_warmingup_notnil(b *testing.B) {
	m := 20

	for i := 1; i < m; i++ {
		_ = notnil( m, i )
	}
}

func Benchmark_notnil10x2000(b *testing.B) {
	m := 10
	o := 2000

	for j := 0; j < o; j ++ {
		for i := 1; i < m; i++ {
			_ = notnil( m, i )
		}
	}
}

func Benchmark_notnil22x8(b *testing.B) {
	m := 22
	o := 8

	for j := 0; j < o; j ++ {
		for i := 1; i < m; i++ {
			_ = notnil( m, i )
		}
	}
}

func Benchmark_warmingup_jeongoon(b *testing.B) {
	m := 20

	for i := 1; i < m; i++ {
		_ = notnil( m, i )
	}
}

func Benchmark_jeongoon10x2000(b *testing.B) {
	m := 10
        o := 2000

	for j := 0; j < o; j ++ {
		for i := 1; i < m; i++ {
			_ = jeongoon( m, i )
		}
	}

}

func Benchmark_jeongoon22x8(b *testing.B) {
	m := 22
	o := 8

	for j := 0; j < o; j ++ {
		for i := 1; i < m; i++ {
			_ = jeongoon( m, i )
		}
	}
}

