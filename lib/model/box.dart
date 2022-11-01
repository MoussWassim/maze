enum Direction { left, right, top, bottom }

class Box {
  late bool isLeftSideWall;
  late bool isRightSideWall;
  late bool isTopSideWall;
  late bool isBottomSideWall;

  Box(
      {this.isLeftSideWall = false,
      this.isRightSideWall = false,
      this.isTopSideWall = false,
      this.isBottomSideWall = false});
}
