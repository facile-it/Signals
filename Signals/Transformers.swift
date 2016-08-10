import Functional

extension DeferredType where WrappedType: WriterType {
	public func mapWriterLift <OtherType> (transform: WrappedType.WrappedType -> OtherType) -> Deferred<Writer<OtherType,WrappedType.LogType>> {
		return map { (writer) -> Writer<OtherType,WrappedType.LogType> in
			writer.map(transform)
		}
	}

	public func flatMapWriterLift <OtherType> (transform: WrappedType.WrappedType -> Writer<OtherType,WrappedType.LogType>) -> Deferred<Writer<OtherType,WrappedType.LogType>> {
		return flatMap { (either) -> Deferred<Writer<OtherType,WrappedType.LogType>> in
			Deferred<Writer<OtherType,WrappedType.LogType>>(either.flatMap(transform))
		}
	}

	public func flatMapWriter <OtherType> (transform: WrappedType.WrappedType -> Deferred<Writer<OtherType,WrappedType.LogType>>) -> Deferred<Writer<OtherType,WrappedType.LogType>> {
		return flatMap { (writer) -> Deferred<Writer<OtherType,WrappedType.LogType>> in
			let newDeferred = Deferred<Writer<OtherType,WrappedType.LogType>>(optionalValue: nil)
			transform(writer.runWriter.0).upon { (newWriter) in
				newDeferred.fill(writer.flatMap { _ in newWriter})
			}
			return newDeferred
		}
	}
}
