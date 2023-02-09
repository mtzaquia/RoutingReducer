/// MIT License
///
/// Copyright (c) 2021 Dariusz Rybicki Darrarski
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

/// Converts a closure `(A) -> B?` to a closure that returns last non-`nil` `B` returned by the input closure.
///
/// Based on a code from [Thomvis/Construct repository](https://github.com/Thomvis/Construct/blob/f165fd005cd939560c1a4eb8d6ee55075a52685d/Construct/Foundation/Memoize.swift)
///
/// - Parameter inputClosure: The input closure.
/// - Returns: Modified closure.
func replayNonNil<A, B>(_ inputClosure: @escaping (A) -> B?) -> (A) -> B? {
  var lastNonNilOutput: B? = nil
  return { inputValue in
    guard let outputValue = inputClosure(inputValue) else {
      return lastNonNilOutput
    }
    lastNonNilOutput = outputValue
    return outputValue
  }
}
