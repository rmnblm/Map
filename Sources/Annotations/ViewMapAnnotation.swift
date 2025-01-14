//
//  ViewMapAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct ViewMapAnnotation<Content: View, ClusterContent: View>: MapAnnotation {

    // MARK: Nested Types

    private class Annotation: NSObject, MKAnnotation {

        // MARK: Stored Properties

        let coordinate: CLLocationCoordinate2D
        let title: String?
        let subtitle: String?

        // MARK: Initialization

        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }

    }

    // MARK: Static Functions

    public static func registerView(on mapView: MKMapView) {
        mapView.register(MKMapAnnotationView<Content, ClusterContent>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
        mapView.register(MKMapClusterView<Content, ClusterContent>.self, forAnnotationViewWithReuseIdentifier: "customClusterReuseIdentifier")
    }

    // MARK: Stored Properties

    public let annotation: MKAnnotation
    let content: (Bool) -> Content
    let clusterContent: (Bool, [MKAnnotation]) -> ClusterContent?
    let clusteringIdentifier: String?

    // MARK: Initialization

    public init(
        coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        subtitle: String? = nil,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: @escaping (Bool) -> Content,
        @ViewBuilder clusterContent: @escaping (Bool, [MKAnnotation]) -> ClusterContent? = { _, _ in nil }
    ) {
        self.annotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle)
        self.content = content
        self.clusterContent = clusterContent
        self.clusteringIdentifier = clusteringIdentifier
    }

    public init(
        annotation: MKAnnotation,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: @escaping (Bool) -> Content,
        @ViewBuilder clusterContent: @escaping (Bool, [MKAnnotation]) -> ClusterContent? = { _, _ in nil }
    ) {
        self.annotation = annotation
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content
        self.clusterContent = clusterContent
    }

    // MARK: Methods

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: Self.reuseIdentifier,
            for: annotation
        ) as? MKMapAnnotationView<Content, ClusterContent>

        view?.setup(for: self)
        return view
    }
    
    public func clusterView(for mapView: MKMapView, clusterAnnotation: MKClusterAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: "customClusterReuseIdentifier",
            for: clusterAnnotation
        ) as? MKMapClusterView<Content, ClusterContent>

        view?.setup(for: self, clusterAnnotation: clusterAnnotation)
        return view
    }
}

#endif
