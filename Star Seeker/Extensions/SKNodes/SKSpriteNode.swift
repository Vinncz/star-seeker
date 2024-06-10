import SpriteKit

extension SKSpriteNode : Sizeable {
    /* SKSpriteNode already has its own size attribute. Sizable only conforms it, so we can use it interchangably with other SKNodes which has extended the Sizable protocol. */
}
