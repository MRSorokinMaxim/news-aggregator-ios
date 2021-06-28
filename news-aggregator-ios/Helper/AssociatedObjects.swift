import Foundation

protocol AssociatedObjects: class { }

extension AssociatedObjects {
    func ao_get<T>(key: UnsafeRawPointer, defaultValue: T) -> T {
        objc_getAssociatedObject(self, key) as? T ?? defaultValue
    }

    func ao_set<T>(value: T, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func ao_removeAll() {
        objc_removeAssociatedObjects(self)
    }
}

extension NSObject: AssociatedObjects { }
