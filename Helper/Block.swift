import Foundation

public typealias Closure<Input, Output> = (Input) -> Output
public typealias ResultClosure<Output> = () -> Output
public typealias ParameterClosure<Input> = Closure<Input, Void>
public typealias VoidBlock = ResultClosure<Void>
public typealias ThrowableClosure<Input, Output> = (Input) throws -> Output
public typealias ThrowableVoidBlock = () throws -> Void
