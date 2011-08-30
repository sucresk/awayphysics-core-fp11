package awayphysics.dynamics.constraintsolver {
	import awayphysics.dynamics.AWPRigidBody;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class AWPGeneric6DofConstraint extends AWPTypedConstraint {
		private var m_linearLimits : AWPTranslationalLimitMotor;
		private var m_angularLimits : Vector.<AWPRotationalLimitMotor>;

		public function AWPGeneric6DofConstraint(rbA : AWPRigidBody, pivotInA : Vector3D, rotationInA : Matrix3D, rbB : AWPRigidBody = null, pivotInB : Vector3D = null, rotationInB : Matrix3D = null, useLinearReferenceFrameA : Boolean = false) {
			m_rbA = rbA;
			m_rbB = rbB;

			var posInA : Vector3D = pivotInA.clone();
			posInA.scaleBy(1 / _scaling);
			var rotArrInA : Vector.<Number> = rotationInA.rawData;
			if (rbB) {
				var posInB : Vector3D = pivotInB.clone();
				posInB.scaleBy(1 / _scaling);
				var rotArrInB : Vector.<Number> = rotationInB.rawData;
				pointer = bullet.createGeneric6DofConstraintMethod2(rbA.pointer, posInA, new Vector3D(rotArrInA[0], rotArrInA[4], rotArrInA[8]), new Vector3D(rotArrInA[1], rotArrInA[5], rotArrInA[9]), new Vector3D(rotArrInA[2], rotArrInA[6], rotArrInA[10]), rbB.pointer, posInB, new Vector3D(rotArrInB[0], rotArrInB[4], rotArrInB[8]), new Vector3D(rotArrInB[1], rotArrInB[5], rotArrInB[9]), new Vector3D(rotArrInB[2], rotArrInB[6], rotArrInB[10]), useLinearReferenceFrameA ? 1 : 0);
			} else {
				pointer = bullet.createGeneric6DofConstraintMethod1(rbA.pointer, posInA.x, posInA.y, posInA.z, rotArrInA[0], rotArrInA[4], rotArrInA[8], rotArrInA[1], rotArrInA[5], rotArrInA[9], rotArrInA[2], rotArrInA[6], rotArrInA[10], useLinearReferenceFrameA ? 1 : 0);
			}

			m_linearLimits = new AWPTranslationalLimitMotor(pointer + 668);

			m_angularLimits = new Vector.<AWPRotationalLimitMotor>(3, true);
			m_angularLimits[0] = new AWPRotationalLimitMotor(pointer + 856);
			m_angularLimits[1] = new AWPRotationalLimitMotor(pointer + 920);
			m_angularLimits[2] = new AWPRotationalLimitMotor(pointer + 984);
		}

		public function getTranslationalLimitMotor() : AWPTranslationalLimitMotor {
			return m_linearLimits;
		}

		public function getRotationalLimitMotor(index : int) : AWPRotationalLimitMotor {
			if (index > 2) return null;
			else return m_angularLimits[index];
		}

		public function setLinearLimit(low : Vector3D, high : Vector3D) : void {
			m_linearLimits.lowerLimit = low;
			m_linearLimits.upperLimit = high;
		}

		public function setAngularLimit(low : Vector3D, high : Vector3D) : void {
			m_angularLimits[0].loLimit = normalizeAngle(low.x);
			m_angularLimits[0].hiLimit = normalizeAngle(high.x);
			m_angularLimits[1].loLimit = normalizeAngle(low.y);
			m_angularLimits[1].hiLimit = normalizeAngle(high.y);
			m_angularLimits[2].loLimit = normalizeAngle(low.z);
			m_angularLimits[2].hiLimit = normalizeAngle(high.z);
		}

		private function normalizeAngle(angleInRadians : Number) : Number {
			var pi2 : Number = 2 * Math.PI;
			var result : Number = angleInRadians % pi2;
			if (result < -Math.PI) {
				return result + pi2;
			} else if (result > Math.PI) {
				return result - pi2;
			} else {
				return result;
			}
		}
	}
}