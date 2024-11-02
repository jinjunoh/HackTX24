// declarations.d.ts
declare module 'react-native-arkit' {
    import { ViewStyle, ReactNode } from 'react-native';
  
    export interface ARKitProps {
      style?: ViewStyle;
      planeDetection?: 'horizontal' | 'vertical'; // Make planeDetection a string union type for simplicity
      lightEstimationEnabled?: boolean;
      debug?: boolean;
      onARKitError?: (error: Error) => void;
      children?: ReactNode; // Allow children to be passed to ARKit
    }
  
    export const ARKit: React.FC<ARKitProps> & {
      Box: React.FC<ARKitObjectProps & { shape: BoxShape }>;
      Sphere: React.FC<ARKitObjectProps & { shape: SphereShape }>;
      Cylinder: React.FC<ARKitObjectProps & { shape: CylinderShape }>;
      Cone: React.FC<ARKitObjectProps & { shape: ConeShape }>;
      Pyramid: React.FC<ARKitObjectProps & { shape: PyramidShape }>;
      Tube: React.FC<ARKitObjectProps & { shape: TubeShape }>;
      Torus: React.FC<ARKitObjectProps & { shape: TorusShape }>;
      Capsule: React.FC<ARKitObjectProps & { shape: CapsuleShape }>;
      Plane: React.FC<ARKitObjectProps & { shape: PlaneShape }>;
    };
  
    interface ARKitObjectProps {
      pos?: { x: number; y: number; z: number };
    }
  
    interface BoxShape {
      width: number;
      height: number;
      length: number;
      chamfer?: number;
    }
  
    interface SphereShape {
      radius: number;
    }
  
    interface CylinderShape {
      radius: number;
      height: number;
    }
  
    interface ConeShape {
      topR: number;
      bottomR: number;
      height: number;
    }
  
    interface PyramidShape {
      width: number;
      height: number;
      length: number;
    }
  
    interface TubeShape {
      innerR: number;
      outerR: number;
      height: number;
    }
  
    interface TorusShape {
      ringR: number;
      pipeR: number;
    }
  
    interface CapsuleShape {
      capR: number;
      height: number;
    }
  
    interface PlaneShape {
      width: number;
      height: number;
    }
  }
  